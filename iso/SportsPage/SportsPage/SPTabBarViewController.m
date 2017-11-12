//
//  BaseTabBarViewController.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPTabBarViewController.h"
#import "SPTabBar.h"
#import "SPNavBar.h"

#import "SPSportsPageViewController.h"

@interface SPTabBarViewController ()

@end

@implementation SPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewControllers];
    [self setUpTabBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUpViewControllers {
    NSArray *classNames = KEY_TABBAR_CLASS_NAME;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:classNames.count];
    
    for (NSString *className in classNames) {
        Class ViewControllerClass = NSClassFromString(className);
        UIViewController *viewController = [[ViewControllerClass alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:navController];
    }
    self.viewControllers = viewControllers;
}

- (void)setUpTabBarItem {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:9],
                                                        NSForegroundColorAttributeName:[UIColor grayColor]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:9],
                                                        NSForegroundColorAttributeName:[SPGlobalConfig themeColor]}
                                             forState:UIControlStateSelected];
    NSArray *titleArray = KEY_TABBAR_TITLE_NAME;
    NSArray *norImageArray = KEY_TABBAR_IMAGE_NORMAL_NAME;
    NSArray *selectedImageArray = KEY_TABBAR_IMAGE_SELECTED_NAME;
    for (int i=0; i<titleArray.count; i++) {
        UINavigationController *navController = (UINavigationController *)self.viewControllers[i];
        navController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArray[i]
                                                                 image:[[UIImage imageNamed:norImageArray[i]]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                         selectedImage:[[UIImage imageNamed:selectedImageArray[i]]
                                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        navController.viewControllers[0].title = titleArray[i];
        if (i == 0 || i == 3) {
            navController.navigationBarHidden = true;
        }
    }
}


#pragma mark - Config
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
