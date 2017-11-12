//
//  SPSportsCreateRequestModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsCreateRequestModel.h"

@implementation SPSportsCreateRequestModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _title = @"";
        _sport_type = @"";
        _sport_item = @"";
        _summary = @"";
        _location = @"";
        _place = @"";
        _longitude = @"";
        _latitude = @"";
        _extend = @"";
    }
    return self;
}

@end
