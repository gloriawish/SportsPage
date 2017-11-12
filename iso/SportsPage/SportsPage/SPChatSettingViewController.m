//
//  SPChatSettingViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPChatSettingViewController.h"

#import "SPFriendSettingTableViewCell.h"

#import "SPIMBusinessUnit.h"
#import "MBProgressHUD.h"

#import "SPIMViewController.h"

#import "SPGroupSettingTableViewCell.h"

#import "SPCheckGroupUsersViewController.h"

#import "SPIMAddGroupMembersViewController.h"

@interface SPChatSettingViewController () <UITableViewDelegate,UITableViewDataSource,SPGroupSettingProtocol> {
    NSMutableArray <NSMutableArray *> *_groupMembersDataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPChatSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_conversationType == ConversationType_GROUP) {
        [self networkRequest];
    }
}

#pragma mark - SetUp
- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"聊天设置";
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
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    if (_conversationType == ConversationType_GROUP) {
        UIButton *deleteFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteFriendButton.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, 50);
        deleteFriendButton.backgroundColor = [SPGlobalConfig anyColorWithRed:229 green:67 blue:64 alpha:1];
        [deleteFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteFriendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [deleteFriendButton setTitle:@"退出群组" forState:UIControlStateNormal];
        [deleteFriendButton addTarget:self action:@selector(exitGroupAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteFriendButton.layer.cornerRadius = 8;
        deleteFriendButton.layer.masksToBounds = true;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [footerView addSubview:deleteFriendButton];
        
        _tableView.tableFooterView = footerView;
    }
}

#pragma mark - NetworkRequest
- (void)networkRequest {
    if (_conversationType == ConversationType_GROUP) {
        [[SPIMBusinessUnit shareInstance] getGroupMembersWithGroupId:_targetId successful:^(NSString *successfulString, JSONModel *model) {
            if ([successfulString isEqualToString:@"successful"]) {
                [self fillDataArray:(SPGroupMembersModel *)model];
            } else {
                NSLog(@"");
            }
        } failure:^(NSString *errorString) {
            NSLog(@"getGroupMembers AFN ERROR:%@",errorString);
        }];
    }
}

- (void)fillDataArray:(SPGroupMembersModel *)model {
    int modelSize = [model.size intValue];
    int count = modelSize/5 + 1;
    
    _groupMembersDataArray = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray <SPUserInfoModel *> *groupMembersArray = [model data];
    
    for (int i=0; i<count; i++) {
        NSMutableArray <SPUserInfoModel *> *eachDataArray = [[NSMutableArray alloc] init];
        if (i != count-1) {
            for (int j=0; j<5; j++) {
                SPUserInfoModel *userModel = [groupMembersArray objectAtIndex:(i*5)+j];
                [eachDataArray addObject:userModel];
            }
        } else {
            int modCount = modelSize%5;
            if (modCount != 0) {
                for (int j=0; j<modCount; j++) {
                    SPUserInfoModel *userModel = [groupMembersArray objectAtIndex:(i*5)+j];
                    [eachDataArray addObject:userModel];
                }
                SPUserInfoModel *userModel = [[SPUserInfoModel alloc] init];
                userModel.isAddIcon = @"1";
                [eachDataArray addObject:userModel];
            } else {
                SPUserInfoModel *userModel = [[SPUserInfoModel alloc] init];
                userModel.isAddIcon = @"1";
                [eachDataArray addObject:userModel];
            }
        }
        [_groupMembersDataArray addObject:eachDataArray];
    }
    [_tableView reloadData];
}

#pragma mark - Action
- (void)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)exitGroupAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认退出群组" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"退出群组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPIMBusinessUnit shareInstance] exitGroupWithUserId:userId groupId:_targetId successful:^(NSString *retString) {
            if ([retString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"退出成功" ToView:self.view];
                });
                if (_indexPath) {
                    __weak SPIMViewController *weakVC = (SPIMViewController *)self.navigationController.viewControllers[0];
                    RCConversationModel *model = weakVC.conversationListDataSource[_indexPath.row];
                    [[RCIMClient sharedRCIMClient] clearMessages:model.conversationType targetId:model.targetId];
                    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:model.targetId];
                    [weakVC.conversationListDataSource removeObjectAtIndex:_indexPath.row];
                    [weakVC.conversationListTableView reloadData];
                    [self.navigationController popToRootViewControllerAnimated:true];
                } else {
                    [self.navigationController popToRootViewControllerAnimated:true];
                }
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:retString ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"exitGroup AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionDelete];
    [alertController addAction:actionCancel];
    [self.navigationController presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_conversationType == ConversationType_GROUP) {
        if (indexPath.section == 0) {
            return 80;
        } else {
            return 40;
        }
    } else {
        return 40;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_conversationType == ConversationType_GROUP) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_conversationType == ConversationType_GROUP) {
        if (section == 0) {
            return _groupMembersDataArray.count;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_conversationType == ConversationType_GROUP) {
        if (indexPath.section == 0) {
            SPGroupSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSettingCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"SPGroupSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GroupSettingCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSettingCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"SPFriendSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FriendSettingCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"SPFriendSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FriendSettingCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_conversationType == ConversationType_GROUP) {
        if (indexPath.section == 0) {
            [(SPGroupSettingTableViewCell *)cell setUpWithModelArray:_groupMembersDataArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [(SPFriendSettingTableViewCell *)cell setCellWithTitle:@"消息免打扰" hiddenMoreImage:true hiddenSwitch:false conversationType:_conversationType targetId:_targetId];
        }
    } else {
        [(SPFriendSettingTableViewCell *)cell setCellWithTitle:@"消息免打扰" hiddenMoreImage:true hiddenSwitch:false conversationType:_conversationType targetId:_targetId];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

#pragma mark - SPGroupSettingProtocol
- (void)groupSettingHeadActionWithTargetId:(NSString *)targetId {
    if ([targetId isEqualToString:@"0"]) {
        SPIMAddGroupMembersViewController *addGroupMembersViewController = [[SPIMAddGroupMembersViewController alloc] init];
        addGroupMembersViewController.targetId = _targetId;
        [self.navigationController presentViewController:addGroupMembersViewController animated:true completion:nil];
    } else {
        SPCheckGroupUsersViewController *checkGroupUsersViewController = [[SPCheckGroupUsersViewController alloc] init];
        checkGroupUsersViewController.targetId = targetId;
        [self.navigationController pushViewController:checkGroupUsersViewController animated:true];
    }
}

@end
