//
//  SPPersonalAccountModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountModel.h"

@implementation SPPersonalAccountModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _accountId = @"";
        _user_id = @"";
        _balance = @"";
        _freeze = @"";
        _score = @"";
        _charge_times = @"";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"accountId":@"id"}];
}

@end
