//
//  SPPersonalAccountDefiniteResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountDefiniteResponseModel.h"

@implementation SPPersonalAccountDefiniteModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _user_id = @"";
        _type = @"";
        _amount = @"";
        _remark = @"";
        _balance = @"";
        _time = @"";
    }
    return self;
}

@end

@implementation SPPersonalAccountDefiniteResponseModel

@end
