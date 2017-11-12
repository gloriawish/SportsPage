//
//  SPPersonalSysSettingViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/17.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalSysSettingViewController.h"

#import "SPPersonalInfoTableViewCell.h"

//#import "SPLoginWayViewController.h"
#import "SPLoginViewController.h"
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"

#import "SPPersonalUpdatePasswordViewController.h"
#import "SPPersonalMessageNotificationViewController.h"
//#import "SPPersonalFeedbackViewController.h"
//#import "SPPersonalAboutUsViewController.h"

#import "SDImageCache.h"
#import "MBProgressHUD.h"

@interface SPPersonalSysSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SPPersonalSysSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _logoutButton.backgroundColor = [SPGlobalConfig themeColor];
    _logoutButton.layer.cornerRadius = 5;
    _logoutButton.layer.masksToBounds = true;
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)logoutButtonAction:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"isAlreadyLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //SPLoginWayViewController *loginWayVC = [[SPLoginWayViewController alloc] init];
    SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navController.navigationBarHidden = true;
    [self.tabBarController presentViewController:navController animated:true completion:^{
        //__weak UITabBarController *tabBarViewController = self.navigationController.tabBarController;
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:false];
        //tabBarViewController.selectedIndex = 0;
        [[RCIM sharedRCIM] logout];
    }];
}

#pragma mark - UIScrollViewDelegatea
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(- scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(- sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
        //return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SPPersonalInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalInfoCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoCell"];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 6)];
    headerView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contentStr = nil;
    NSString *imageName = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            contentStr = @"消息通知";
            imageName = @"Mine_sys_notification";
        } else if (indexPath.row == 1) {
            [(SPPersonalInfoTableViewCell *)cell lineView].hidden = true;
            contentStr = @"修改密码";
            imageName = @"Mine_sys_renewPassword";
        }
    } else {
        if (indexPath.row == 0) {
            contentStr = @"清理缓存";
            imageName = @"Mine_sys_cache";
        }
//        else if (indexPath.row == 1) {
//            contentStr = @"意见反馈";
//            imageName = @"Mine_sys_feedback";
//        } else {
//            contentStr = @"关于我们";
//            imageName = @"Mine_sys_aboutus";
//        }
    }
    [(SPPersonalInfoTableViewCell *)cell setUpWithTitle:contentStr content:@"" imageName:imageName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SPPersonalMessageNotificationViewController *messageNotificationViewController = [[SPPersonalMessageNotificationViewController alloc] init];
            [self.navigationController pushViewController:messageNotificationViewController animated:true];
        } else {
            SPPersonalUpdatePasswordViewController *rePasswordViewController = [[SPPersonalUpdatePasswordViewController alloc] init];
            rePasswordViewController.titleStr = @"修改密码";
            rePasswordViewController.passwordNameStr = @"新密码";
            [self.navigationController pushViewController:rePasswordViewController animated:true];
        }
    } else {
        if (indexPath.row == 0) {
            
            SDImageCache *cache = [SDImageCache sharedImageCache];
            float tempSize = [cache getSize] / 1024.0 / 1024.0;
            NSString *clearCacheSizeStr = nil;
            if (tempSize >= 1) {
                clearCacheSizeStr = [NSString stringWithFormat:@"是否清理缓存(%.2fM)",tempSize];
            } else {
                clearCacheSizeStr = [NSString stringWithFormat:@"是否清理缓存(%.2fK)",tempSize * 1024];
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:clearCacheSizeStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [cache clearDiskOnCompletion:^{
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    [SPGlobalConfig showTextOfHUD:@"清理成功" ToView:self.view];
                }];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:action2];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:true completion:nil];
        }
//        else if (indexPath.row == 1) {
//            SPPersonalFeedbackViewController *feedbackViewController = [[SPPersonalFeedbackViewController alloc] init];
//            [self.navigationController pushViewController:feedbackViewController animated:true];
//        } else {
//            SPPersonalAboutUsViewController *aboutUsViewController = [[SPPersonalAboutUsViewController alloc] init];
//            [self.navigationController pushViewController:aboutUsViewController animated:true];
//        }
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
