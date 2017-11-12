//
//  SPCheckFriendViewController.h
//  SportsPage
//
//  Created by absolute on 2016/10/20.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPCheckFriendViewController : SPBaseViewController

@property (nonatomic,readwrite,copy) NSString *userId;
@property (nonatomic,readwrite,assign) BOOL selfUserId;
@property (nonatomic,readwrite,assign) BOOL turnFromChat;
@property (nonatomic,readwrite,assign) BOOL turnFromContacts;

@end
