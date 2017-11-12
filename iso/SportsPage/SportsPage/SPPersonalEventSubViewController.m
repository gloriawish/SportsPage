//
//  SPPersonalEventSubViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalEventSubViewController.h"
#import "SPPersonalEventSubTableViewCell.h"

#import "SPPINGBusinessUnit.h"
#import "SPPersonalEventResponseModel.h"

#import "MJRefresh.h"

#import "SPSportsEventViewController.h"
#import "SPSportsSettleViewController.h"
#import "SPSportsAppraiseViewController.h"

@interface SPPersonalEventSubViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPPersonalEventModel *>*_allDataArray;
    NSMutableArray <SPPersonalEventModel *>*_progressDataArray;
    NSMutableArray <SPPersonalEventModel *>*_settleDataArray;
    NSMutableArray <SPPersonalEventModel *>*_evaluationDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPPersonalEventSubViewController

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
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    
    _requestOffset = 0;
    _requestSize = 10;
    
    if (_tableViewIndex == 1) {
        _allDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControlWithDataArray:_allDataArray];
    } else if (_tableViewIndex == 2) {
        _progressDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControlWithDataArray:_progressDataArray];
    } else if (_tableViewIndex == 3) {
        _settleDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControlWithDataArray:_settleDataArray];
    } else if (_tableViewIndex == 4) {
        _evaluationDataArray = [[NSMutableArray alloc] init];
        [self setUpRefreshControlWithDataArray:_evaluationDataArray];
    } else {
        NSLog(@"tableViewIndex:%lu",(long)_tableViewIndex);
    }
}

- (void)setUpRefreshControlWithDataArray:(NSMutableArray <SPPersonalEventModel *>*)dataArray {
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
        [[SPPINGBusinessUnit shareInstance] getMineOrdersWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *>*tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    _allDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_allDataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
                _tableView.mj_footer.hidden = false;
                _requestOffset = 0;
            } else {
                NSLog(@"%@",successsfulString);
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getMineOrders AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 2) {
        [[SPPINGBusinessUnit shareInstance] getOrdersIngWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *>*tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    _progressDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_progressDataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
                _tableView.mj_footer.hidden = false;
                _requestOffset = 0;
            } else {
                NSLog(@"%@",successsfulString);
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getOrdersIng AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 3) {
        [[SPPINGBusinessUnit shareInstance] getOrdersSettlementWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *>*tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    _settleDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_settleDataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
                _tableView.mj_footer.hidden = false;
                _requestOffset = 0;
            } else {
                NSLog(@"%@",successsfulString);
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getOrdersAppraise AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 4) {
        [[SPPINGBusinessUnit shareInstance] getOrdersAppraiseWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *>*tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    _evaluationDataArray = tempArray;
                    if (tempArray.count < _requestSize) {
                        [_tableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_tableView.mj_footer resetNoMoreData];
                    }
                } else {
                    [_evaluationDataArray removeAllObjects];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [_tableView.mj_header endRefreshing];
                [_tableView reloadData];
                _tableView.mj_footer.hidden = false;
                _requestOffset = 0;
            } else {
                NSLog(@"%@",successsfulString);
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getOrdersSettlement AFN ERROR:%@",errorString);
        }];
    }
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size type:(NSInteger)typeNum {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    if (typeNum == 1) {
        [[SPPINGBusinessUnit shareInstance] getMineOrdersWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *> *tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    [_allDataArray addObjectsFromArray:tempArray];
                    [_tableView.mj_footer endRefreshing];
                    [_tableView reloadData];
                } else {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 2) {
        [[SPPINGBusinessUnit shareInstance] getOrdersIngWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *> *tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    [_progressDataArray addObjectsFromArray:tempArray];
                    [_tableView.mj_footer endRefreshing];
                    [_tableView reloadData];
                } else {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 3) {
        [[SPPINGBusinessUnit shareInstance] getOrdersSettlementWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *> *tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    [_settleDataArray addObjectsFromArray:tempArray];
                    [_tableView.mj_footer endRefreshing];
                    [_tableView reloadData];
                } else {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        }];
    } else if (typeNum == 4) {
        [[SPPINGBusinessUnit shareInstance] getOrdersAppraiseWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
            if ([successsfulString isEqualToString:@"successful"]) {
                NSMutableArray <SPPersonalEventModel *> *tempArray = ((SPPersonalEventResponseModel *)jsonModel).data;
                if (tempArray.count != 0) {
                    [_evaluationDataArray addObjectsFromArray:tempArray];
                    [_tableView.mj_footer endRefreshing];
                    [_tableView reloadData];
                } else {
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        }];
    }
    
}

#pragma mark - UITableViewDelegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    header.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//    return header;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableViewIndex == 1) {
        return _allDataArray.count;
    } else if (_tableViewIndex == 2) {
        return _progressDataArray.count;
    } else if (_tableViewIndex == 3) {
        return _settleDataArray.count;
    } else if (_tableViewIndex == 4) {
        return _evaluationDataArray.count;
    } else {
        NSLog(@"tableViewIndex:%lu",(long)_tableViewIndex);
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH*31/64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalEventSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalEventSubCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalEventSubTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalEventSubCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalEventSubCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableViewIndex == 1) {
        [(SPPersonalEventSubTableViewCell *)cell setUpWithModel:_allDataArray[indexPath.row]];
    } else if (_tableViewIndex == 2) {
        [(SPPersonalEventSubTableViewCell *)cell setUpWithModel:_progressDataArray[indexPath.row]];
    } else if (_tableViewIndex == 3) {
        [(SPPersonalEventSubTableViewCell *)cell setUpWithModel:_settleDataArray[indexPath.row]];
    } else if (_tableViewIndex == 4) {
        [(SPPersonalEventSubTableViewCell *)cell setUpWithModel:_evaluationDataArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSMutableArray <SPPersonalEventModel *>*tempDataArray;
    if (_tableViewIndex == 1) {
        tempDataArray = _allDataArray;
    } else if (_tableViewIndex == 2) {
        tempDataArray = _progressDataArray;
    } else if (_tableViewIndex == 3) {
        tempDataArray = _settleDataArray;
    } else if (_tableViewIndex == 4) {
        tempDataArray = _evaluationDataArray;
    }
    
    NSString *statusStr = tempDataArray[indexPath.row].status;
    if ([statusStr isEqualToString:@"待结算"]) {
        SPPersonalEventModel *model = tempDataArray[indexPath.row];

        SPSportsSettleViewController *settleViewController = [[SPSportsSettleViewController alloc] init];
        NSString *priceStr = [NSString stringWithFormat:@"%ld",[model.enroll_number integerValue]*[model.price integerValue]];
        settleViewController.priceStr = priceStr;
        settleViewController.eventId = model.event_id;
        
        SPEventModel *eventModel = [[SPEventModel alloc] init];
        eventModel.title = model.title;
        eventModel.charge_type = model.charge_type;
        eventModel.price = model.price;
        eventModel.location = model.location;
        eventModel.start_time = model.start_time;
        eventModel.end_time = model.end_time;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:[model.enroll_number integerValue]];
        eventModel.enrollUsers = tempArray;
#pragma clang diagnostic pop
        [settleViewController setUpWithModel:eventModel];
        [self.navigationController pushViewController:settleViewController animated:true];
    } else if ([statusStr isEqualToString:@"待评价"]) {
        SPPersonalEventModel *model = tempDataArray[indexPath.row];
        SPSportsAppraiseViewController *appraiseViewController = [[SPSportsAppraiseViewController alloc] init];
        [appraiseViewController setUpWithImage:nil
                                         title:model.title
                                      location:model.location
                                          time:model.start_time
                                      initiate:model.creator
                                       eventId:model.event_id
                                      imageUrl:model.portrait];
        [self.navigationController pushViewController:appraiseViewController animated:true];
    } else {
        SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
        sportsEventViewController.eventId = tempDataArray[indexPath.row].event_id;
        [self.navigationController pushViewController:sportsEventViewController animated:true];
    }
}

@end
