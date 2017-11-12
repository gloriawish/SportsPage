//
//  SPSportsClubUnbindSportsPageViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubUnbindSportsPageViewController.h"

#import "SPPersonalSportsPageTableViewCell.h"

#import "SPPersonalSportsPageUnbindTableViewCell.h"

#import "SPSportsPageResponseModel.h"

#import "SPSportBusinessUnit.h"

#import "MJRefresh.h"

#import "MBProgressHUD.h"

@interface SPSportsClubUnbindSportsPageViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSString *_clubId;
    NSMutableArray <SPSportsPageModel *>*_dataArray;
    NSMutableArray <NSIndexPath *>*_indexArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bindSportsPageButton;

@end

@implementation SPSportsClubUnbindSportsPageViewController

- (instancetype)initWithClubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        _clubId = clubId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setUp
- (void)setUp {
    [_bindSportsPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self setUpTableView];
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tintColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    _dataArray = [[NSMutableArray alloc] init];
    _indexArray = [[NSMutableArray alloc] init];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    _tableView.mj_header = header;
    
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

- (void)requestData {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] getClubUnbindSportUserId:userId clubId:_clubId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            _dataArray = [(SPSportsPageResponseModel *)jsonModel data];
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
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

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)bindSportsPageAction:(UIButton *)sender {
    
    sender.userInteractionEnabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    NSMutableArray *strArray = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in _indexArray) {
        [strArray addObject:_dataArray[indexPath.row].sportId];
    }
    NSString *targetIdStr = [strArray componentsJoinedByString:@","];
    NSLog(@"%@",targetIdStr);
    
    [[SPSportBusinessUnit shareInstance] bindSportToClubBatchWithUserId:userId clubId:_clubId sportIds:targetIdStr successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"绑定成功" ToView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([_delegate respondsToSelector:@selector(finishedBindReloadAction)]) {
                        [_delegate finishedBindReloadAction];
                    }
                    [self.navigationController popViewControllerAnimated:true];
                });
                
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
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
    SPPersonalSportsPageUnbindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSportsPageUnbindCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalSportsPageUnbindTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalSportsPageUnbindCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalSportsPageUnbindCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPPersonalSportsPageUnbindTableViewCell *)cell setUpWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalSportsPageUnbindTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([cell isSelectedImage]) {
        [_indexArray removeObject:indexPath];
    } else {
        if (![_indexArray containsObject:indexPath]) {
            [_indexArray addObject:indexPath];
        }
    }
    [cell changeSelectedImageStatus];
}

@end
