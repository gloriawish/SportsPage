//
//  SPChatSettingViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import <RongIMKit/RongIMKit.h>

@interface SPChatSettingViewController : SPBaseViewController

@property (nonatomic,assign) RCConversationType conversationType;
@property (nonatomic,copy) NSString *targetId;

@property (nonatomic,readwrite,strong) NSIndexPath *indexPath;

@end
