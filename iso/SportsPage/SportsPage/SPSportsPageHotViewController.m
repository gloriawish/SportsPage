//
//  SPSportsPageHotViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageHotViewController.h"
#import "SPSportsPageMainTableViewCell.h"

#import "SPSportsEventViewController.h"

#import "SPSportsMainModel.h"
#import "SPSportBusinessUnit.h"
#import "AppDelegate.h"

#import "MJRefresh.h"

#import "SPSportsMainSearchResultTableViewController.h"
//UISearchResultsUpdating
@interface SPSportsPageHotViewController () <UISearchControllerDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,SPSportsMainSearchResultProtocol> {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPSportsMainResponseModel *>*_hotDataArray;
    
    SPSportsMainSearchResultTableViewController *_searchResultViewController;
}

@property (weak, nonatomic) IBOutlet UITableView *hotTableView;

//@property (nonatomic,readwrite,strong) NSMutableArray <SPSportsMainResponseModel *> *searchResultsArray;
@property (nonatomic,readwrite,strong) UISearchController *searchController;

@end

@implementation SPSportsPageHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

#pragma mark - SetUp
- (void)setUp {
    
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _hotTableView.showsVerticalScrollIndicator = false;
    
    _searchResultViewController = [[SPSportsMainSearchResultTableViewController alloc] init];
    _searchResultViewController.delegate = self;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultViewController];
    _searchController.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.obscuresBackgroundDuringPresentation = false;
    //_searchController.hidesNavigationBarDuringPresentation = true;
    
    //_searchController.searchResultsUpdater = self;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    
    _hotTableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = true;
    
    _requestOffset = 0;
    _requestSize = 10;
    
    _hotDataArray = [[NSMutableArray alloc] init];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithOffset:0 size:_requestSize];
    }];
    //header.backgroundColor = [UIColor orangeColor];
    _hotTableView.mj_header = header;
    [_hotTableView bringSubviewToFront:_hotTableView.mj_header];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestOffset = _requestOffset + _requestSize;
        [self requestMoreDataWithOffset:_requestOffset size:_requestSize];
    }];
    footer.triggerAutomaticallyRefreshPercent = 0.1;
    //footer.backgroundColor = [UIColor orangeColor];
    _hotTableView.mj_footer = footer;
    _hotTableView.mj_footer.hidden = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_hotTableView setContentOffset:CGPointMake(0, -60)];
            } completion:^(BOOL finished) {
                [_hotTableView.mj_header beginRefreshing];
            }];
        });
    });
}

#pragma mark - Refresh
- (void)requestDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    NSString *latitude = @"999";
    NSString *longitude = @"999";
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.longitude != 999) {
        latitude = [NSString stringWithFormat:@"%lf",delegate.latitude];
        longitude = [NSString stringWithFormat:@"%lf",delegate.longitude];
    }
    
    [[SPSportBusinessUnit shareInstance] getHotEventWithUserId:userId offset:offsetStr size:sizeStr latitude:latitude longitude:longitude successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                _hotDataArray = tempArray;
                if (tempArray.count < _requestSize) {
                    [_hotTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_hotTableView.mj_footer resetNoMoreData];
                }
            } else {
                [_hotDataArray removeAllObjects];
                [_hotTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_hotTableView.mj_header endRefreshing];
            [_hotTableView reloadData];
            _hotTableView.mj_footer.hidden = false;
            _requestOffset = 0;
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_hotTableView.mj_header endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_hotTableView.mj_header endRefreshing];
    }];
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    NSString *latitude = @"999";
    NSString *longitude = @"999";
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.longitude != 999) {
        latitude = [NSString stringWithFormat:@"%lf",delegate.latitude];
        longitude = [NSString stringWithFormat:@"%lf",delegate.longitude];
    }
    
    [[SPSportBusinessUnit shareInstance] getHotEventWithUserId:userId offset:offsetStr size:sizeStr latitude:latitude longitude:longitude successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                [_hotDataArray addObjectsFromArray:tempArray];
                [_hotTableView.mj_footer endRefreshing];
                [_hotTableView reloadData];
            } else {
                [_hotTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_hotTableView.mj_footer endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_hotTableView.mj_footer endRefreshing];
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
    SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
    sportsEventViewController.eventId = _hotDataArray[indexPath.row].event_id;
    sportsEventViewController.hidesBottomBarWhenPushed = true;
    [_pageViewController.navigationController pushViewController:sportsEventViewController animated:true];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(SPSportsPageMainTableViewCell *)cell setUpWithModel:_hotDataArray[indexPath.row]];
}

#pragma mark - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_MAIN_CHANGE_TITLE object:nil userInfo:@{@"action":@"presentSearchController"}];
    [UIView animateWithDuration:0.5 animations:^{
        _hotTableView.alpha = 0;
    }];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_MAIN_CHANGE_TITLE object:nil userInfo:@{@"action":@"dismissSearchController"}];
    [UIView animateWithDuration:0.5 animations:^{
        _hotTableView.alpha = 1;
    }];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
}


#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *searchText = _searchController.searchBar.text;
    if (searchText.length != 0) {
        [_searchResultViewController searchEventWithSearchKey:searchText];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [_searchResultViewController searchResultEndAction];
    return true;
}

#pragma mark SPSportsMainSearchResultProtocol
- (void)searchResultTurnToNextPageWithEventId:(NSString *)eventId {
    SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
    sportsEventViewController.eventId = eventId;
    sportsEventViewController.hidesBottomBarWhenPushed = true;
    [_pageViewController.navigationController pushViewController:sportsEventViewController animated:true];
}

@end
