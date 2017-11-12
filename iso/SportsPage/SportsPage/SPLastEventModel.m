//
//  SPLastEventModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPLastEventModel.h"

@implementation SPLastEventModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sport_id = @"";
        _user_id = @"";
        _team_type = @"";
        _charge_type = @"";
        _privacy = @"";
        _level = @"";
        _min_number = @"";
        _max_number = @"";
        _price = @"";
        _start_time = @"";
        _duration = @"";
        _operate_time = @"";
        _status = @"";
        _time = @"";

    }
    return self;
}

@end
