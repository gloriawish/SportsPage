//
//  SPChatGroupViewController.h
//  SportsPage
//
//  Created by Qin on 2017/1/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SPChatGroupViewController : RCConversationViewController

@property (nonatomic,readwrite,strong) RCConversationModel *model;
@property (nonatomic,readwrite,strong) NSIndexPath *indexPath;

@end
