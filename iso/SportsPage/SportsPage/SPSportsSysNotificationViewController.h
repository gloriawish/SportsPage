//
//  SPSportsSysNotificationViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPSportsNotificationViewController.h"

@interface SPSportsSysNotificationViewController : SPBaseViewController

@property (nonatomic,readwrite,assign) NSInteger tableViewIndex;
@property (nonatomic,readwrite,weak) SPSportsNotificationViewController *notificationViewController;

@end
