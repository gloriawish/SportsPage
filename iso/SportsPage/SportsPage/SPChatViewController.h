//
//  SPChatViewController.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SPChatViewController : RCConversationViewController

@property (nonatomic,readwrite,strong) RCConversationModel *model;
@property (nonatomic,readwrite,strong) NSIndexPath *indexPath;

@end
