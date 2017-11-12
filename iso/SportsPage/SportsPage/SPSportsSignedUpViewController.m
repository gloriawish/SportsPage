//
//  SPSportsSignedUpViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSignedUpViewController.h"

#import "SPSportsSignedUpTableViewCell.h"
#import "SPSportsSignedUpManagerViewController.h"

#import "SPIMBusinessUnit.h"

#import "MBProgressHUD.h"

#import "SPSportsCheckFriendsViewController.h"

@interface SPSportsSignedUpViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation SPSportsSignedUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPORTS_MANAGER_ADD_FRIENDS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SPORTS_MANAGER_CHECK_FRIENDS object:nil];
}

#pragma mark - SetUp
- (void)setUp {
    [self dataHandle];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    [_rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAddFriendsAction:) name:NOTIFICATION_SPORTS_MANAGER_ADD_FRIENDS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCheckFriendsAction:) name:NOTIFICATION_SPORTS_MANAGER_CHECK_FRIENDS object:nil];
}

- (void)dataHandle {
    NSInteger count = -1;
    for (int i=0; i<_dataArray.count; i++) {
        SPUserInfoModel *model = _dataArray[i];
        if ([model.relation isEqualToString:@"-1"]) {
            count = i;
            break;
        }
    }
    if (count != -1) {
        SPUserInfoModel *model = _dataArray[count];
        [_dataArray removeObjectAtIndex:count];
        [_dataArray insertObject:model atIndex:0];
    }
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)rightButtonAction:(id)sender {
    SPSportsSignedUpManagerViewController *managerViewController = [[SPSportsSignedUpManagerViewController alloc] init];
    managerViewController.initiateInfoModel = _initiateInfoModel;
    managerViewController.dataArray = _dataArray;
    [self.navigationController pushViewController:managerViewController animated:true];
}

- (void)notificationAddFriendsAction:(NSNotification *)notification {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    _tableView.userInteractionEnabled = false;
    NSString *target = notification.userInfo[@"targetId"];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] addFriendWithUserId:userId friendId:target message:@"" extra:@"" successful:^(NSString *retString) {
        if ([retString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"请求发送成功" ToView:self.view];
                _tableView.userInteractionEnabled = true;
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:retString ToView:self.view];
                _tableView.userInteractionEnabled = true;
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            _tableView.userInteractionEnabled = true;
        });
    }];
}

- (void)notificationCheckFriendsAction:(NSNotification *)notification {
    NSString *target = notification.userInfo[@"targetId"];
    
    SPSportsCheckFriendsViewController *checkFriendsViewController = [[SPSportsCheckFriendsViewController alloc] init];
    checkFriendsViewController.targetId = target;
    [self.navigationController pushViewController:checkFriendsViewController animated:true];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 20)];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    if (section == 0) {
        label.text = @"发起人";
    } else {
        label.text = @"参与人";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPSportsSignedUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportsSignedUpCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPSportsSignedUpTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsSignedUpCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"SportsSignedUpCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SPUserInfoModel *model = _initiateInfoModel;
        NSString *initiateStr = nil;
        if (model.nick.length != 0) {
            initiateStr = model.nick;
        } else {
            initiateStr = model.uname;
        }
        [(SPSportsSignedUpTableViewCell *)cell setUpWithImageName:model.portrait initiate:initiateStr type:model.relation targetId:model.userId];
        ((SPSportsSignedUpTableViewCell *)cell).signedUpViewController = self;
    } else {
        SPUserInfoModel *model = _dataArray[indexPath.row];
        NSString *initiateStr = nil;
        if (model.nick.length != 0) {
            initiateStr = model.nick;
        } else {
            initiateStr = model.uname;
        }
        [(SPSportsSignedUpTableViewCell *)cell setUpWithImageName:model.portrait initiate:initiateStr type:model.relation targetId:model.userId];
        ((SPSportsSignedUpTableViewCell *)cell).signedUpViewController = self;
    }
}

@end
