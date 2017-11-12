//
//  SPPersonalEventResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalEventResponseModel.h"

@implementation SPPersonalEventModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _event_id = @"";
        _title = @"";
        _location = @"";
        _start_time = @"";
        _end_time = @"";
        _portrait = @"";
        _creator = @"";
        _sport_item = @"";
        _charge_type = @"";
        _price = @"";
        _max_number = @"";
        _enroll_number = @"";
        _status = @"";
        _type = @"";
    }
    return self;
}

@end

@implementation SPPersonalEventResponseModel

@end
