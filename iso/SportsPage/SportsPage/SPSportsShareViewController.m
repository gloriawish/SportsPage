//
//  SPSportsShareViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsShareViewController.h"

#import "SPSportsShareGroupsViewController.h"
#import "SPSportsShareFriendsViewController.h"

@interface SPSportsShareViewController ()

@end

@implementation SPSportsShareViewController

- (void)defaultController {
    self.pageAnimatable = true;
    self.menuBGColor = [UIColor whiteColor];
    self.menuHeight = 35;
    self.menuItemWidth = SCREEN_WIDTH/4;
    self.titleColorSelected = [SPGlobalConfig themeColor];
    self.menuViewStyle = WMMenuViewStyleLine;
    self.titleSizeSelected = 15;
    self.progressViewIsNaughty = true;
    self.progressColor = [SPGlobalConfig themeColor];
    self.progressWidth = 40;
    self.progressHeight = 5;
}

- (void)viewDidLoad {
    [self defaultController];
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 1)];
    //lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    lineView.backgroundColor = [[SPGlobalConfig themeColor] colorWithAlphaComponent:0.5];
    [self.menuView addSubview:lineView];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - WMPageControllerDelegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        SPSportsShareFriendsViewController *shareFriends = [[SPSportsShareFriendsViewController alloc] init];
        shareFriends.shareBaseViewController = self;
        return shareFriends;
    } else {
        SPSportsShareGroupsViewController *shareGroups = [[SPSportsShareGroupsViewController alloc] init];
        shareGroups.shareBaseViewController = self;
        return shareGroups;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"我的好友";
    } else {
        return @"我的群组";
    }
}

@end
