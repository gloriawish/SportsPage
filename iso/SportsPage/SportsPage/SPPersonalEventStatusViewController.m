//
//  SPPersonalEventStatusViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalEventStatusViewController.h"
#import "SPPersonalEventSubViewController.h"

@interface SPPersonalEventStatusViewController ()

@end

@implementation SPPersonalEventStatusViewController

- (void)defaultController {
    self.pageAnimatable = true;
    self.menuBGColor = [UIColor whiteColor];
    self.menuHeight = 35;
    self.menuItemWidth = SCREEN_WIDTH/4;
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
    return 4;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    SPPersonalEventSubViewController *subViewController = [[SPPersonalEventSubViewController alloc] init];
    subViewController.tableViewIndex = index+1;
    return subViewController;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"全部";
    } else if (index == 1) {
        return @"进行中";
    } else if (index == 2) {
        return @"待结算";
    } else {
        return @"待评价";
    }
}

@end
