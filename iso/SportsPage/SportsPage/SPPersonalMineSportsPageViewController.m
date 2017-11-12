//
//  SPPersonalMineSportsPageViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalMineSportsPageViewController.h"
#import "SPPersonalSportsPageTableViewCell.h"

#import "SPSportsPageResponseModel.h"
#import "SPSportBusinessUnit.h"

#import "SPSportsEventViewController.h"
#import "SPSportsPageBaseViewController.h"

#import "MJRefresh.h"

@interface SPPersonalMineSportsPageViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray <SPSportsPageModel *>*_dataArray;
    NSInteger _requestOffset;
    NSInteger _requestSize;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalMineSportsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _requestOffset = 0;
    _requestSize = 10;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithOffset:0 size:_requestSize];
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

#pragma mark - Refresh
- (void)requestDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] getMineSportWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsPageModel *> *tempArray = ((SPSportsPageResponseModel *)jsonModel).data;
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
            [_tableView.mj_header endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getMineSport AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] getMineSportWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsPageModel *> *tempArray = ((SPSportsPageResponseModel *)jsonModel).data;
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
        NSLog(@"getMineSport AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalSportsPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSportsPageCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalSportsPageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalSportsPageCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSportsPageCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPPersonalSportsPageTableViewCell *)cell setUpWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([_dataArray[indexPath.row].status isEqualToString:@"0"]) {
        SPSportsPageBaseViewController *sportsPageViewController = [[SPSportsPageBaseViewController alloc] init];
        sportsPageViewController.sportId = _dataArray[indexPath.row].sportId;
        [self.navigationController pushViewController:sportsPageViewController animated:true];
    } else if ([_dataArray[indexPath.row].status isEqualToString:@"1"]) {
        SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
        sportsEventViewController.eventId = _dataArray[indexPath.row].event_id;
        [self.navigationController pushViewController:sportsEventViewController animated:true];
    }
}

@end
