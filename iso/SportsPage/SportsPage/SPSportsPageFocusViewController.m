//
//  SPSportsPageFocusViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageFocusViewController.h"
#import "SPSportsPageFocusTableViewCell.h"

#import "SPCreateSportsViewController.h"
#import "SPSportsEventViewController.h"
#import "SPSportsPageBaseViewController.h"

#import "SPSportsMainModel.h"
#import "SPSportBusinessUnit.h"

#import "MJRefresh.h"

@interface SPSportsPageFocusViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSInteger _requestOffset;
    NSInteger _requestSize;
    NSMutableArray <SPSportsMainResponseModel *>*_focusDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *focusTableView;

@end

@implementation SPSportsPageFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    
    //self.navigationController.interactivePopGestureRecognizer.enabled = false;
    
    _focusTableView.delegate = self;
    _focusTableView.dataSource = self;
    _focusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _focusTableView.showsVerticalScrollIndicator = false;

    _requestOffset = 0;
    _requestSize = 10;
    
    _focusDataArray = [[NSMutableArray alloc] init];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithOffset:0 size:_requestSize];
    }];
    //header.backgroundColor = [UIColor orangeColor];
    _focusTableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _requestOffset = _requestOffset + _requestSize;
        [self requestMoreDataWithOffset:_requestOffset size:_requestSize];
    }];
    footer.triggerAutomaticallyRefreshPercent = 0.1;
    //footer.backgroundColor = [UIColor orangeColor];
    _focusTableView.mj_footer = footer;
    _focusTableView.mj_footer.hidden = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_focusTableView setContentOffset:CGPointMake(0, -60)];
            } completion:^(BOOL finished) {
                [_focusTableView.mj_header beginRefreshing];
            }];
        });
    });
}

#pragma mark - Refresh
- (void)requestDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] getFollowEventWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                _focusDataArray = tempArray;
                if (tempArray.count < _requestSize) {
                    [_focusTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_focusTableView.mj_footer resetNoMoreData];
                }
            } else {
                [_focusDataArray removeAllObjects];
                [_focusTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_focusTableView.mj_header endRefreshing];
            [_focusTableView reloadData];
            _focusTableView.mj_footer.hidden = false;
            _requestOffset = 0;
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_focusTableView.mj_header endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_focusTableView.mj_header endRefreshing];
    }];
}

- (void)requestMoreDataWithOffset:(NSInteger)offset size:(NSInteger)size {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *sizeStr = [NSString stringWithFormat:@"%ld",(long)size];
    
    [[SPSportBusinessUnit shareInstance] getFollowEventWithUserId:userId offset:offsetStr size:sizeStr successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            NSMutableArray <SPSportsMainResponseModel *> *tempArray = ((SPSportsMainModel *)jsonModel).data;
            if (tempArray.count != 0) {
                [_focusDataArray addObjectsFromArray:tempArray];
                [_focusTableView.mj_footer resetNoMoreData];
                [_focusTableView reloadData];
            } else {
                [_focusTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
            [_focusTableView.mj_header endRefreshing];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getHotEvent AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        [_focusTableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _focusDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 333 * SCREEN_WIDTH / 375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsPageFocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FocusCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsPageFocusTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FocusCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FocusCell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_focusDataArray[indexPath.row].event_id.length == 0) {
        SPSportsPageBaseViewController *sportsPageViewController = [[SPSportsPageBaseViewController alloc] init];
        sportsPageViewController.sportId = _focusDataArray[indexPath.row].sportId;
        sportsPageViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:sportsPageViewController animated:true];
    } else {
        SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
        sportsEventViewController.eventId = _focusDataArray[indexPath.row].event_id;
        sportsEventViewController.hidesBottomBarWhenPushed = true;
        [_pageViewController.navigationController pushViewController:sportsEventViewController animated:true];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    CATransform3D rotation;
//    rotation = CATransform3DMakeRotation( M_PI_4/2 , 0.0, 0.7, 0.4);
//    rotation = CATransform3DScale(rotation, 0.8, 0.8, 1);
//    rotation.m34 = 1.0/ 1000;
//    cell.layer.shadowColor = [[UIColor whiteColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    cell.layer.transform = rotation;
//    [UIView beginAnimations:@"rotation" context:NULL];
//    [UIView setAnimationDuration:0.6];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
    [(SPSportsPageFocusTableViewCell *)cell setUpWithModel:_focusDataArray[indexPath.row]];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
