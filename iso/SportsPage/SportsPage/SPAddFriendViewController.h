//
//  SPAddFriendViewController.h
//  SportsPage
//
//  Created by absolute on 2016/10/20.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import "SPUserInfoModel.h"

@interface SPAddFriendViewController : SPBaseViewController

@property (nonatomic,readwrite,copy) NSString *targetId;
@property (nonatomic,readwrite,strong) NSIndexPath *indexPath;

@end
