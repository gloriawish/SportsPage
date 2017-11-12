//
//  SPSportsPageResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageResponseModel.h"

@implementation SPSportsPageModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sportId = @"";
        _event_id = @"";
        _user_id = @"";
        _title = @"";
        _portrait = @"";
        _summary = @"";
        _sport_type = @"";
        _sport_item = @"";
        _location = @"";
        _location_detail = @"";
        _place = @"";
        _latitude = @"";
        _longitude = @"";
        _geohash = @"";
        _active_times = @"";
        _grade = @"";
        _status = @"";
        _time = @"";
        _deleted = @"";
        _extend = @"";
        _valid = @"";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sportId":@"id"}];
}

@end

@implementation SPSportsPageResponseModel

@end
