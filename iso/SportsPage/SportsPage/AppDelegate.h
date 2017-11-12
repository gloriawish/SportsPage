//
//  AppDelegate.h
//  SportsPage
//
//  Created by absolute on 2016/10/17.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TencentOAuth;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (assign,nonatomic,readwrite) double longitude;
@property (assign,nonatomic,readwrite) double latitude;

@property (strong,nonatomic,readwrite) NSMutableArray *friendsSortedListArray;
@property (strong,nonatomic,readwrite) NSMutableArray *friendsListArray;

@property (copy,nonatomic,readwrite) NSString *pingppResult;
@property (copy,nonatomic,readwrite) NSString *payAmount;

@end

