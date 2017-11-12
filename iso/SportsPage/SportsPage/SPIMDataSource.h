//
//  SPIMDataSource.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"

@interface SPIMDataSource : NSObject <RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource,
                                        RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate>

#pragma mark - Singleton
+ (instancetype)shareInstance;

@end
