//
//  SPSettingFriendViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/20.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSettingFriendViewController.h"
#import "SPFriendSettingTableViewCell.h"

#import "AppDelegate.h"
#import "SPIMBusinessUnit.h"

#import "MBProgressHUD.h"

#import "SPIMViewController.h"
#import "SPContactViewController.h"

@interface SPSettingFriendViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSettingFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpNav {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"资料设置";
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
    
    UIButton *deleteFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteFriendButton.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, 50);
    deleteFriendButton.backgroundColor = [SPGlobalConfig anyColorWithRed:229 green:67 blue:64 alpha:1];
    [deleteFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteFriendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteFriendButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteFriendButton addTarget:self action:@selector(footerViewClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteFriendButton.layer.cornerRadius = 8;
    deleteFriendButton.layer.masksToBounds = true;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [footerView addSubview:deleteFriendButton];
    
    _tableView.tableFooterView = footerView;
}

#pragma mark - Action
- (void)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)footerViewClickedAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认将此联系人删除" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPIMBusinessUnit shareInstance] deleteFriendWithUserId:userId friendId:_targetId successful:^(NSString *retString) {
            
            if ([retString isEqualToString:@"successful"]) {
                
                //刷新全局好友列表
                [[SPIMBusinessUnit shareInstance] getFriendsListWithUserId:userId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.friendsSortedListArray = friendsSortedList;
                    delegate.friendsListArray = friendsList;
                    NSLog(@"重新获取好友缓存成功");

                    __weak UIViewController *rootViewController = self.navigationController.viewControllers[0];
                    if ([rootViewController isMemberOfClass:[SPContactViewController class]]) {
                        [(SPContactViewController *)rootViewController prepareForFriendsData];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOAD_CONVERSATION object:nil userInfo:@{@"targetId":_targetId}];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:true];
                    });
                    
                } failure:^(NSString *errorString) {
                    NSLog(@"网络请求好友数据失败:%@",errorString);
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"删除失败" ToView:self.view];
                    });
                }];
                
            } else {
                NSLog(@"%@",retString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"删除失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"删除失败" ToView:self.view];
            });
        }];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionDelete];
    [alertController addAction:actionCancel];
    [self.navigationController presentViewController:alertController animated:true completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPFriendSettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FriendSettingCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSettingCell"];
    }
    return cell;
}

#warning 个人设置 设置备注，黑名单，投诉 TODO
- (void)tableView:(UITableView *)tableView willDisplayCell:(SPFriendSettingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [cell setCellWithTitle:@"设置备注" hiddenMoreImage:false hiddenSwitch:true];
        cell.userInteractionEnabled = false;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell setCellWithTitle:@"加入黑名单" hiddenMoreImage:true hiddenSwitch:false];
            cell.userInteractionEnabled = false;
        } else {
            [cell setCellWithTitle:@"投诉" hiddenMoreImage:false hiddenSwitch:true];
            cell.userInteractionEnabled = false;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [SPGlobalConfig anyColorWithRed:247 green:247 blue:247 alpha:1];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

@end
