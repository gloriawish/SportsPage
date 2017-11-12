//
//  SPGroupModel.m
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPGroupModel.h"

@implementation SPGroupModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _groupId = @"";
        _name = @"";
        _portrait = @"";
        _introduce = @"";
        _size = @"";
        _extend = @"";
        _owner = @"";
        _create_time = @"";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"groupId":@"id"}];
}

@end
