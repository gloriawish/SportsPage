//
//  SPSportsClubRelationSportsPageViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubRelationSportsPageViewController.h"

#import "SPPersonalSportsPageTableViewCell.h"

#import "SPSportsEventViewController.h"
#import "SPSportsPageBaseViewController.h"

#import "SPSportsPageResponseModel.h"

#import "SPSportBusinessUnit.h"

#import "MJRefresh.h"

#import "SPSportsClubUnbindSportsPageViewController.h"

@interface SPSportsClubRelationSportsPageViewController () <UITableViewDelegate,UITableViewDataSource,SPSportsClubUnbindSportsPageViewControllerProtocol> {
    NSString *_clubId;
    NSString *_permission;
    NSMutableArray <SPSportsPageModel *>*_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bindSportsPageButton;

@end

@implementation SPSportsClubRelationSportsPageViewController

- (instancetype)initWithClubId:(NSString *)clubId permission:(NSString *)permission {
    self = [super init];
    if (self) {
        _clubId = clubId;
        _permission = permission;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    
    if ([_permission isEqualToString:@"0"]) {
        _bindSportsPageButton.hidden = true;
    } else {
        [_bindSportsPageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _dataArray = [[NSMutableArray alloc] init];
    
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
    
    [[SPSportBusinessUnit shareInstance] getClubBindSportsUserId:userId clubId:_clubId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        
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

- (IBAction)bindSportsPageAction:(id)sender {
    SPSportsClubUnbindSportsPageViewController *unbinSportsPageViewController = [[SPSportsClubUnbindSportsPageViewController alloc] initWithClubId:_clubId];
    unbinSportsPageViewController.delegate = self;
    [self.navigationController pushViewController:unbinSportsPageViewController animated:true];
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

#pragma mark - SPSportsClubUnbindSportsPageViewControllerProtocol
- (void)finishedBindReloadAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                [_tableView setContentOffset:CGPointMake(0, -60)];
            } completion:^(BOOL finished) {
                [_tableView.mj_header beginRefreshing];
                
                if ([_delegate respondsToSelector:@selector(finishedBindReloadAction)]) {
                    [_delegate finishedBindReloadAction];
                }
                
            }];
        });
    });
}


@end
