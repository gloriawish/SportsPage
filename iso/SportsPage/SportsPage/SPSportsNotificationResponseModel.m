//
//  SPSportsNotificationResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsNotificationResponseModel.h"

@implementation SPSportsNotificationModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = @"";
        _target_id = @"";
        _content = @"";
        _extend = @"";
        _time = @"";
        _is_read = @"";
    }
    return self;
}

@end

@implementation SPSportsNotificationResponseModel

@end
