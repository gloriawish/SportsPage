//
//  SPSportsSysNotificationViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSysNotificationViewController.h"

#import "SPSportsNotificationResponseModel.h"

#import "SPUserBusinessUnit.h"
#import "MJRefresh.h"

#import "SPSportsSysNotificationTableViewCell.h"
#import "SPSportsSpNotificationTableViewCell.h"

#import "SPSportsEventViewController.h"

@interface SPSportsSysNotificationViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPSportsNotificationModel *>*_sysNotificationDataArray;
    NSMutableArray <SPSportsNotificationModel *>*_spNotificationDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsSysNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _requestOffset = 0;
    _requestSize = 10;
    
    if (_tableViewIndex == 1) {
        _sysNotificationDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControl];
    } else if (_tableViewIndex == 2) {
        _spNotificationDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControl];
    } else {
        NSLog(@"tableViewIndex:%lu",(long)_tableViewIndex);
    }
    
}

- (void)setUpRefreshControl {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithOffset:0 size:_requestSize type:_tableViewIndex];
    }];
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestOffset = _requestOffset + _requestSize;
        [self requestMoreDataWithOffset:_requestOffset size:_requestSize type:_tableViewIndex];
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

#pragma mark - NetworkRequest
- (void)requestDataWithOffset:(NSInteger)offset size:(NSInteger)size type:(NSInteger)typeNum {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    if (typeNum == 1) {
        [[SPUserBusinessUnit shareInstance] getNotifyWithUserId:userId type:@"info" offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *model) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPSportsNotificationModel *> *tempArray = ((SPSportsNotificationResponseModel *)model).data;
                if (tempArray.count != 0) {
                    _sysNotificationDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_sysNotificationDataArray removeAllObjects];
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
            NSLog(@"getNotify AFN ERROR:%@",errorString);
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            [_tableView.mj_header endRefreshing];
        }];
    } else if (typeNum == 2) {
        [[SPUserBusinessUnit shareInstance] getNotifyWithUserId:userId type:@"sp" offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *model) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPSportsNotificationModel *> *tempArray = ((SPSportsNotificationResponseModel *)model).data;
                if (tempArray.count != 0) {
                    _spNotificationDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_spNotificationDataArray removeAllObjects];
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
            NSLog(@"getNotify AFN ERROR:%@",errorString);
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            [_tableView.mj_header endRefreshing];
        }];
    }
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size type:(NSInteger)typeNum {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    if (typeNum == 1) {
        [[SPUserBusinessUnit shareInstance] getNotifyWithUserId:userId type:@"info" offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *model) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPSportsNotificationModel *> *tempArray = ((SPSportsNotificationResponseModel *)model).data;
                if (tempArray.count != 0) {
                    [_sysNotificationDataArray addObjectsFromArray:tempArray];
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
            NSLog(@"getNotify AFN ERROR:%@",errorString);
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            [_tableView.mj_header endRefreshing];
        }];
    } else if (typeNum == 2) {
        [[SPUserBusinessUnit shareInstance] getNotifyWithUserId:userId type:@"sp" offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *model) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPSportsNotificationModel *> *tempArray = ((SPSportsNotificationResponseModel *)model).data;
                if (tempArray.count != 0) {
                    [_spNotificationDataArray addObjectsFromArray:tempArray];
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
            NSLog(@"getNotify AFN ERROR:%@",errorString);
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            [_tableView.mj_header endRefreshing];
        }];
    }
}

#pragma mark - Action

#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    header.backgroundColor = [SPGlobalConfig themeColor];
//    return header;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableViewIndex == 1) {
        return 100;
    } else {
        if ([_spNotificationDataArray[indexPath.row].type isEqualToString:@"2001"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2002"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2004"]) {
            return 130;
        } else {
            return 100;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableViewIndex == 1) {
        return _sysNotificationDataArray.count;
    } else {
        return _spNotificationDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableViewIndex == 1) {
        SPSportsSysNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysNotificationCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPSportsSysNotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SysNotificationCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"SysNotificationCell"];
        }
        cell.userInteractionEnabled = false;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if ([_spNotificationDataArray[indexPath.row].type isEqualToString:@"2001"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2002"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2004"]) {
            SPSportsSpNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpNotificationCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"SPSportsSpNotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SpNotificationCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"SpNotificationCell"];
            }
            return cell;
        } else {
            SPSportsSysNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysNotificationCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"SPSportsSysNotificationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SysNotificationCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"SysNotificationCell"];
            }
            cell.userInteractionEnabled = false;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableViewIndex == 1) {
        [(SPSportsSysNotificationTableViewCell *)cell setUpWithModel:_sysNotificationDataArray[indexPath.row]];
    } else if (_tableViewIndex == 2) {
        if ([_spNotificationDataArray[indexPath.row].type isEqualToString:@"2001"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2002"]
            || [_spNotificationDataArray[indexPath.row].type isEqualToString:@"2004"]) {
            [(SPSportsSpNotificationTableViewCell *)cell setUpWithModel:_spNotificationDataArray[indexPath.row]];
        } else {
            [(SPSportsSysNotificationTableViewCell *)cell setUpWithModel:_spNotificationDataArray[indexPath.row]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //extend
    if (_tableViewIndex == 2) {
        NSString *eventId = _spNotificationDataArray[indexPath.row].extend;
        if (eventId.length != 0) {
            
            SPSportsEventViewController *eventController = [[SPSportsEventViewController alloc] init];
            eventController.eventId = eventId;
            [self.navigationController pushViewController:eventController animated:true];
            
        } else {
            NSLog(@"extend长度为0");
        }
    }
    
}

@end
