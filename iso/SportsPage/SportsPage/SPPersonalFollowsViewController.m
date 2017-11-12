//
//  SPPersonalFollowsViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalFollowsViewController.h"
#import "SPSportsFollowsResponseModel.h"
#import "SPPersonalFollowsTableViewCell.h"

#import "SPSportBusinessUnit.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "SPSportsPageBaseViewController.h"

@interface SPPersonalFollowsViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPSportsFollowsModel *> *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalFollowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_MINE_FOCUS_RECORD_ACTION object:nil];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:NOTIFICATION_MINE_FOCUS_RECORD_ACTION object:nil];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _requestOffset = 0;
    _requestSize = 10;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestOffset = _requestOffset + _requestSize;
        [self requestMoreDataWithOffset:_requestOffset size:_requestSize];
    }];
    footer.triggerAutomaticallyRefreshPercent = 0.1;
    _tableView.mj_footer = footer;
    _tableView.mj_footer.hidden = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_tableView setContentOffset:CGPointMake(0, -60)];
            } completion:^(BOOL finished) {
                [_tableView.mj_header beginRefreshing];
            }];
        });
    });
    
}

#pragma mark - RequestData
- (void)requestData {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getFollowsWithUserId:userId offset:@"0" size:@"10" successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsFollowsModel *> *tempArray = ((SPSportsFollowsResponseModel *)jsonModel).data;
            if (tempArray.count != 0) {
                _dataArray = tempArray;
                if (tempArray.count < _requestSize) {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_tableView.mj_footer resetNoMoreData];
                }
            } else {
                [_dataArray removeAllObjects];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
            _tableView.mj_footer.hidden = false;
            _requestOffset = 0;
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getFollows AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] getFollowsWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsFollowsModel *> *tempArray = ((SPSportsFollowsResponseModel *)jsonModel).data;
            if (tempArray.count != 0) {
                [_dataArray addObjectsFromArray:tempArray];
                [_tableView.mj_footer endRefreshing];
                [_tableView reloadData];
            } else {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getFollows AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark - NotificationAction
- (void)notificationAction:(NSNotification *)notification {
    NSString *focusAction = notification.userInfo[@"focusAction"];
    NSString *sportId = notification.userInfo[@"sportId"];
    SPPersonalFollowsTableViewCell *cell = notification.userInfo[@"cell"];

    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if ([focusAction isEqualToString:@"cancel"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否取消关注" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tableView.userInteractionEnabled = false;
            [MBProgressHUD showHUDAddedTo:self.view animated:true];
            [[SPSportBusinessUnit shareInstance] cancelFollowWithUserId:userId sportId:sportId successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"取消关注成功" ToView:self.view];
                        self.tableView.userInteractionEnabled = true;
                        cell.isFocus = false;
                        [cell.focusButton setBackgroundImage:[UIImage imageNamed:@"Mine_focus_record_unfocus"] forState:UIControlStateNormal];
                    });
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                        self.tableView.userInteractionEnabled = true;
                    });
                }
            } failure:^(NSString *errorString) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    self.tableView.userInteractionEnabled = true;
                });
            }];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionCancel];
        [alert addAction:actionSure];
        [self presentViewController:alert animated:true completion:nil];

    } else if ([focusAction isEqualToString:@"focus"]) {
        self.tableView.userInteractionEnabled = false;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPSportBusinessUnit shareInstance] followWithUserId:userId sportId:sportId successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"关注成功" ToView:self.view];
                    self.tableView.userInteractionEnabled = true;
                    cell.isFocus = true;
                    [cell.focusButton setBackgroundImage:[UIImage imageNamed:@"Mine_focus_record_focus"] forState:UIControlStateNormal];
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    self.tableView.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalFollowsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalFollowsCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalFollowsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalFollowsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalFollowsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsFollowsModel *model = _dataArray[indexPath.row];
    [(SPPersonalFollowsTableViewCell *)cell setUpWithImageName:model.portrait type:model.sport_item title:model.title initiate:model.creator location:model.location sportId:model.sport_id];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    SPSportsPageBaseViewController *sportsPageViewController = [[SPSportsPageBaseViewController alloc] init];
    sportsPageViewController.sportId = _dataArray[indexPath.row].sport_id;
    [self.navigationController pushViewController:sportsPageViewController animated:true];
}

@end
