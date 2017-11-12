//
//  SPSportsMainSearchResultTableViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsMainSearchResultTableViewController.h"
#import "SPSportsPageMainTableViewCell.h"
#import "SPSportsEventViewController.h"

#import "SPSportBusinessUnit.h"
#import "SPSportsMainModel.h"

#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface SPSportsMainSearchResultTableViewController () {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPSportsMainResponseModel *>*_hotDataArray;
    
    NSString *_searchKey;
}

@end

@implementation SPSportsMainSearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"创建VC");
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)searchResultEndAction {
    [_hotDataArray removeAllObjects];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = true;
}

- (void)searchEventWithSearchKey:(NSString *)searchKey {
    _searchKey = searchKey;
    _requestOffset = 0;
    [self requestDataWithOffset:_requestOffset size:_requestSize search:searchKey];
}

#pragma mark - SetUp
- (void)setUp {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = false;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    
    _requestOffset = 0;
    _requestSize = 10;
    
    _hotDataArray = [[NSMutableArray alloc] init];

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestOffset = _requestOffset + _requestSize;
        [self requestMoreDataWithOffset:_requestOffset size:_requestSize];
    }];
    footer.triggerAutomaticallyRefreshPercent = 0.1;
    //footer.backgroundColor = [UIColor orangeColor];
    self.tableView.mj_footer = footer;
    self.tableView.mj_footer.hidden = true;
}

#pragma mark - Refresh
- (void)requestDataWithOffset:(NSInteger)offset size:(NSInteger)size search:(NSString *)searchKey {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    [[SPSportBusinessUnit shareInstance] searchEventWithUserId:userId searchKey:searchKey offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                _hotDataArray = tempArray;
                if (tempArray.count < _requestSize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer resetNoMoreData];
                }
            } else {
                [_hotDataArray removeAllObjects];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            self.tableView.mj_footer.hidden = false;
            _requestOffset = 0;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"searchEvent AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] searchEventWithUserId:userId searchKey:_searchKey offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                [_hotDataArray addObjectsFromArray:tempArray];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        [self.tableView.mj_footer endRefreshing];
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hotDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270 * SCREEN_WIDTH / 375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsPageMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsPageMainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MainCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([self.delegate respondsToSelector:@selector(searchResultTurnToNextPageWithEventId:)]) {
        [self.delegate searchResultTurnToNextPageWithEventId:_hotDataArray[indexPath.row].event_id];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPSportsPageMainTableViewCell *)cell setUpWithModel:_hotDataArray[indexPath.row]];
}

@end
