//
//  SPPersonalMainSportsPageViewController.m
//  SportsPage
//
//  Created by Qin on 2017/1/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalMainSportsPageViewController.h"

#import "SPPersonalMineSportsPageViewController.h"
#import "SPPersonalFollowsViewController.h"

@interface SPPersonalMainSportsPageViewController ()

@end

@implementation SPPersonalMainSportsPageViewController

- (void)defaultController {
    self.pageAnimatable = true;
    self.menuBGColor = [UIColor whiteColor];
    self.menuHeight = 35;
    self.menuItemWidth = SCREEN_WIDTH/2;
    self.titleColorSelected = [SPGlobalConfig themeColor];
    //self.bounces = true;
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
        SPPersonalMineSportsPageViewController *sportsPageViewController = [[SPPersonalMineSportsPageViewController alloc] init];
        return sportsPageViewController;
    } else {
        SPPersonalFollowsViewController *followsViewController = [[SPPersonalFollowsViewController alloc] init];
        return followsViewController;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"运动页";
    } else {
        return @"关注记录";
    }
}

@end
