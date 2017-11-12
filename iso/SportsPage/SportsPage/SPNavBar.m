//
//  SPNavigationBar.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPNavBar.h"

#define CHANGE_NAV_FLAG 0

@implementation SPNavBar

- (instancetype)initWithWeakNavController:(UINavigationController *)weakNavController {
    self = [super init];
    if (self) {
#ifdef CHANGE_TAB_FLAG
        [[[self class] appearance] setBarTintColor:[UIColor colorWithRed:18/255.0
                                                                   green:183/255.0
                                                                    blue:245/255.0
                                                                   alpha:1.0]];
        UIViewController *rootViewController = weakNavController.viewControllers[0];
        NSString *classString = NSStringFromClass([rootViewController class]);
        if ([classString isEqualToString:@"SPSportsPageViewController"] ) {
            [self setUpSportsPageNavBar:rootViewController];
        } else if ([classString isEqualToString:@"SPIMViewController"]) {
            [self setUpIMNavBar:rootViewController];
        } else if ([classString isEqualToString:@"SPContactViewController"]) {
            [self setUpContactNavBar:rootViewController];
        } else if ([classString isEqualToString:@"SPPersonalViewController"]) {
            [self setUpPersonalNavBar:rootViewController];
        }
#else
        
#endif
    }
    return self;
}

#pragma mark - SetUp
- (void)setUpSportsPageNavBar:(UIViewController *)rootViewController {
    
}

- (void)setUpIMNavBar:(UIViewController *)rootViewController {
    
}

- (void)setUpContactNavBar:(UIViewController *)rootViewController {
    
}

- (void)setUpPersonalNavBar:(UIViewController *)rootViewController {
    
}

@end
