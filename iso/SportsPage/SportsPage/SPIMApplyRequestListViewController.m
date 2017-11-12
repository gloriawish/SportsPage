//
//  SPIMApplyRequestListViewController.m
//  SportsPage
//
//  Created by Qin on 2017/4/5.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMApplyRequestListViewController.h"

#import "SPSportBusinessUnit.h"
#import "SPClubApplyListResponseModel.h"

#import "MJRefresh.h"

#import "SPClubInviewListTableViewCell.h"

#import "SPCheckFriendViewController.h"

@interface SPIMApplyRequestListViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray <SPClubApplyListModel *> *_clubApplyListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPIMApplyRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpNav];
    [self setUpTableView];
}

- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"俱乐部申请";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *negativeSpacerL = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    negativeSpacerL.width = -20;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacerL, backBarButtonItem];
    
}

- (void)setUpTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self networkRequest];
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

- (void)networkRequest {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    [[SPSportBusinessUnit shareInstance] getClubApplyListWithUserId:userId successful:^(NSString *successsfulString, JSONModel *jsonModel) {
        if ([successsfulString isEqualToString:@"successful"]) {
            SPClubApplyListResponseModel *model = (SPClubApplyListResponseModel *)jsonModel;
            _clubApplyListArray = model.data;
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
        } else {
            [_tableView.mj_header endRefreshing];
            [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
        }
    } failure:^(NSString *errorString) {
        [_tableView.mj_header endRefreshing];
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
    
}

#pragma mark - Action
- (void)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _clubApplyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPClubInviewListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubInviewListTableViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPClubInviewListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClubInviewListTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClubInviewListTableViewCell"];
    }
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SPClubInviewListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setUpApplyModel:_clubApplyListArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPCheckFriendViewController *checkFriendViewController = [[SPCheckFriendViewController alloc] init];
    checkFriendViewController.userId = _clubApplyListArray[indexPath.row].from_id;
    checkFriendViewController.selfUserId = true;
    [self.navigationController pushViewController:checkFriendViewController animated:true];
}

@end
