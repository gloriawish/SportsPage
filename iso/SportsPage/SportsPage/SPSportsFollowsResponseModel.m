//
//  SPSportsFollowsResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsFollowsResponseModel.h"

@implementation SPSportsFollowsModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _sport_id = @"";
        _portrait = @"";
        _title = @"";
        _creator = @"";
        _location = @"";
        _sport_item = @"";
        _extend = @"";
    }
    return self;
}

@end

@implementation SPSportsFollowsResponseModel

@end
