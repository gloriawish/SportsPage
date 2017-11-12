//
//  SPCheckFriendViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/20.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCheckFriendViewController.h"
#import "SPIMBusinessUnit.h"

#import "SPSettingFriendViewController.h"
#import "SPChatViewController.h"
#import "SPUserInfoTableViewCell.h"
#import "SPOtherInfoTableViewCell.h"

#import "AppDelegate.h"

@interface SPCheckFriendViewController () <UITableViewDelegate,UITableViewDataSource> {
    SPUserInfoModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPCheckFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
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
    titleLabel.text = @"详细资料";
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
    
    if (!_selfUserId) {
        
        UIBarButtonItem *negativeSpacerR = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                         target:nil
                                                                                         action:nil];
        negativeSpacerR.width = -20;
        UIButton *friendsSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        friendsSettingButton.frame = CGRectMake(0, 0, 55, 30);
        [friendsSettingButton setBackgroundImage:[UIImage imageNamed:@"IM_friendsSetting"] forState:UIControlStateNormal];
        [friendsSettingButton addTarget:self action:@selector(userSettingAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *chatSettingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:friendsSettingButton];
        self.navigationItem.rightBarButtonItems = @[negativeSpacerR, chatSettingBarButtonItem];
    
//        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(userSettingAction:)];
//        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)setUp {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    
    if (!_selfUserId) {
        UIButton *sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageButton.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, 50);
        sendMessageButton.backgroundColor = [SPGlobalConfig themeColor];
        [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendMessageButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [sendMessageButton setTitle:@"发消息" forState:UIControlStateNormal];
        [sendMessageButton addTarget:self action:@selector(footerViewClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        sendMessageButton.layer.cornerRadius = 8;
        sendMessageButton.layer.masksToBounds = true;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [footerView addSubview:sendMessageButton];
        
        _tableView.tableFooterView = footerView;
    }
}

#pragma mark - NetworkRequest
- (void)networkRequest {
    [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:_userId success:^(JSONModel *model) {
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
- (void)navBackAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)userSettingAction:(id)sender {
    NSLog(@"moreSettingAction:");
    SPSettingFriendViewController *settingFriendVC = [[SPSettingFriendViewController alloc] init];
    settingFriendVC.targetId = _userId;
    [self.navigationController pushViewController:settingFriendVC animated:true];
}

- (void)footerViewClickedAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"发消息"]) {
        if (_turnFromChat) {
            [self.navigationController popViewControllerAnimated:true];
        } else if (_turnFromContacts) {
            SPChatViewController *chatViewController = [[SPChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:_userId];
            chatViewController.hidesBottomBarWhenPushed = true;
            RCConversationModel *model = [[RCConversationModel alloc] init];
            if (_userModel.remark.length != 0) {
                model.conversationTitle = _userModel.remark;
            } else {
                model.conversationTitle = _userModel.nick;
            }
            model.conversationType = ConversationType_PRIVATE;
            model.targetId = _userId;
            chatViewController.model = model;
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            ((UITabBarController *)delegate.window.rootViewController).selectedIndex = 1;
            [self.navigationController popViewControllerAnimated:false];
            [((UITabBarController *)delegate.window.rootViewController).selectedViewController pushViewController:chatViewController animated:true];
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_selfUserId) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_selfUserId) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return 1;
        } else {
            //return 2;
            return 1;
        }
    } else {
        if (section == 0) {
            return 1;
        } else {
            //return 2;
            return 1;
        }
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

#warning 详细资料 设置备注 更多 TODO
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_selfUserId) {
        if (indexPath.section == 0) {
            [(SPUserInfoTableViewCell *)cell setupWithUserInfoModel:_userModel];
            cell.userInteractionEnabled = false;
        } else if (indexPath.section == 1) {
            [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"设置备注";
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
                cell.userInteractionEnabled = false;
            }
        }
    } else {
        if (indexPath.section == 0) {
            [(SPUserInfoTableViewCell *)cell setupWithUserInfoModel:_userModel];
            cell.userInteractionEnabled = false;
        } else {
            if (indexPath.row == 0) {
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
            } else {
                [(SPOtherInfoTableViewCell *)cell titleLabel].text = @"更多";
                cell.userInteractionEnabled = false;
            }
        }
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:true];
//}

@end
