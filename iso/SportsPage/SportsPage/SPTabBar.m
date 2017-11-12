//
//  SPTabBar.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPTabBar.h"

#define CHANGE_TAB_FLAG 0

@implementation SPTabBar

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef CHANGE_TAB_FLAG
        [[[self class] appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
#else
        
#endif
    }
    return self;
}

@end
