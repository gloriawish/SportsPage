//
//  SPSportsClubMembersListCheckMembersViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubMembersListCheckMembersViewController.h"

#import "SPChatViewController.h"

#import "SPUserInfoTableViewCell.h"
#import "SPOtherInfoTableViewCell.h"

#import "SPIMBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPSportsClubMembersListCheckMembersViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSString *_targetId;
    SPUserInfoModel *_userModel;
    UIButton *_actionButton;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSportsClubMembersListCheckMembersViewController

- (instancetype)initWithTargetId:(NSString *)targetId {
    self = [super init];
    if (self) {
        _targetId = targetId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    [self setUpTableView];
}

- (void)setUpTableView {
    _tableView.hidden = true;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self setUpTableViewFooter];
}

- (void)setUpTableViewFooter {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    if (![userId isEqualToString:_targetId]) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        footView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(31, 0, SCREEN_WIDTH-62, 50);
        _actionButton.layer.cornerRadius = 5;
        _actionButton.layer.masksToBounds = true;
        [_actionButton setBackgroundColor:[SPGlobalConfig themeColor]];
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_actionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.userInteractionEnabled = false;
        [footView addSubview:_actionButton];
        _tableView.tableFooterView = footView;
    }
    
}

- (void)networkRequest {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] getUserInfoByRelationWithUserId:userId targetId:_targetId success:^(JSONModel *model) {
        if (model) {
            [self reloadAction:(SPUserInfoModel *)model];
        } else {
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getUserInfoByRelationWithUserId,AFN ERROR:%@",errorString);
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)reloadAction:(SPUserInfoModel *)model {
    _userModel = model;
    
    if ([_userModel.relation isEqualToString:@"0"]) {
        [_actionButton setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    } else if ([_userModel.relation isEqualToString:@"1"]) {
        [_actionButton setTitle:@"发消息" forState:UIControlStateNormal];
    } else {
        _actionButton.hidden = true;
    }
    _actionButton.userInteractionEnabled = true;
    _tableView.hidden = false;
    [_tableView reloadData];
}

- (void)buttonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"添加到通讯录"]) {
        [self addFriendAction:sender];
    } else if ([sender.currentTitle isEqualToString:@"发消息"]) {
        [self sendMessageAction:sender];
    }
}

- (void)addFriendAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] addFriendWithUserId:userId friendId:_targetId message:@"" extra:@"" successful:^(NSString *retString) {
        if ([retString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"添加请求发送成功" ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:retString ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            sender.userInteractionEnabled = true;
        });
    }];
}

- (void)sendMessageAction:(UIButton *)sender {
    SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                                             targetId:_targetId];
    chatViewController.hidesBottomBarWhenPushed = true;
    RCConversationModel *model = [[RCConversationModel alloc] init];
    model.conversationTitle = _userModel.nick;
    model.conversationType = ConversationType_PRIVATE;
    model.targetId = _targetId;
    chatViewController.model = model;
    
    __weak UITabBarController *tabBarController = self.tabBarController;
    tabBarController.selectedIndex = 1;
    
    [self.navigationController popToRootViewControllerAnimated:false];
    
    [(UINavigationController *)tabBarController.viewControllers[1] pushViewController:chatViewController animated:true];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else {
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPUserInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UserInfoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OtherInfoCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPOtherInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherInfoCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"OtherInfoCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [(SPUserInfoTableViewCell *)cell setupWithUserInfoModel:_userModel];
        cell.userInteractionEnabled = false;
    } else if (indexPath.section == 1) {
        [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"地区";
        if (_userModel.city.length == 0 && _userModel.area.length == 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = @"保密";
        } else if (_userModel.city.length == 0 && _userModel.area.length != 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userModel.area;
        } else if (_userModel.city.length != 0 && _userModel.area.length == 0) {
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = _userModel.city;
        } else if (_userModel.city.length != 0 && _userModel.area.length != 0) {
            NSString *areaStr = [NSString stringWithFormat:@"%@ %@",_userModel.city,_userModel.area];
            [(SPOtherInfoTableViewCell *)cell contentLabel].text = areaStr;
        }
        [(SPOtherInfoTableViewCell *)cell moreImage].hidden = true;
        cell.userInteractionEnabled = false;
    }
}



@end
