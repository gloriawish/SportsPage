//
//  SPAddFriendViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/20.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPAddFriendViewController.h"
#import "SPIMBusinessUnit.h"

#import "SPIMViewController.h"
#import "SPUserInfoTableViewCell.h"
#import "SPOtherInfoTableViewCell.h"

#import "AppDelegate.h"

#import "MBProgressHUD.h"

@interface SPAddFriendViewController () <UITableViewDelegate,UITableViewDataSource> {
    SPUserInfoModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"好友请求";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -20;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 50, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backBarButtonItem];
}

- (void)setUp {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    
    UIButton *confirmAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmAddButton.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, 50);
    confirmAddButton.backgroundColor = [SPGlobalConfig themeColor];
    [confirmAddButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmAddButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [confirmAddButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [confirmAddButton addTarget:self action:@selector(confirmAddFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmAddButton.layer.cornerRadius = 8;
    confirmAddButton.layer.masksToBounds = true;
    
    UIButton *ignoreMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ignoreMessageButton.frame = CGRectMake(25, 70, SCREEN_WIDTH-50, 50);
    ignoreMessageButton.backgroundColor = [SPGlobalConfig anyColorWithRed:229 green:67 blue:64 alpha:1];
    [ignoreMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ignoreMessageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [ignoreMessageButton setTitle:@"忽略请求" forState:UIControlStateNormal];
    [ignoreMessageButton addTarget:self action:@selector(ignoredAction:) forControlEvents:UIControlEventTouchUpInside];
    ignoreMessageButton.layer.cornerRadius = 8;
    ignoreMessageButton.layer.masksToBounds = true;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    [footerView addSubview:confirmAddButton];
    [footerView addSubview:ignoreMessageButton];
    _tableView.tableFooterView = footerView;
    
}

- (void)networkRequest {
    [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:_targetId success:^(JSONModel *model) {
        if (model) {
            NSLog(@"获取用户信息成功");
            _userModel = (SPUserInfoModel *)model;
            [_tableView reloadData];
        } else {
            NSLog(@"获取用户信息失败");
        }
    } failure:^(NSString *errorString) {
        NSLog(@"获取用户信息失败:%@",errorString);
    }];
}

#pragma mark - Action
- (void)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)ignoredAction:(id)sender {
    __weak SPIMViewController *weakVC = (SPIMViewController *)self.navigationController.viewControllers[0];
    [weakVC rcConversationListTableView:weakVC.conversationListTableView
                     commitEditingStyle:UITableViewCellEditingStyleDelete
                      forRowAtIndexPath:_indexPath];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)confirmAddFriendAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [[SPIMBusinessUnit shareInstance] processRequestFriendWithUserId:userId friendId:_targetId isAccess:@"true" successful:^(NSString *retString) {
        
        if ([retString isEqualToString:@"successful"]) {
            //刷新全局好友列表
            [[SPIMBusinessUnit shareInstance] getFriendsListWithUserId:userId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
                if (friendsList.count != 0 && friendsSortedList.count != 0) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.friendsSortedListArray = friendsSortedList;
                    delegate.friendsListArray = friendsList;
                    NSLog(@"重新获取好友缓存成功");
                    
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        __weak SPIMViewController *weakVC = (SPIMViewController *)self.navigationController.viewControllers[0];
                        [weakVC rcConversationListTableView:weakVC.conversationListTableView
                                         commitEditingStyle:UITableViewCellEditingStyleDelete
                                          forRowAtIndexPath:_indexPath];
                        [SPGlobalConfig showTextOfHUD:@"添加成功" ToView:weakVC.view];
                        [self.navigationController popViewControllerAnimated:true];
                    });
                }
            } failure:^(NSString *errorString) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"添加失败" ToView:self.view];
                });
                NSLog(@"网络请求好友数据失败:%@",errorString);
            }];
        } else {
            NSLog(@"error:%@",retString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"添加失败" ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"添加失败" ToView:self.view];
        });
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
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
    } else {
        if (indexPath.row == 0) {
            [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"地区";
            if (_userModel.city.length == 0 && _userModel.area.length == 0) {
                [(SPOtherInfoTableViewCell *)cell contentLabel].text = @"未填写";
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
        } else {
            [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"更多";
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
@end
