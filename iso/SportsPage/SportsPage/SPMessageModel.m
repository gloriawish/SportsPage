//
//  SPMessageModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/2.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPMessageModel.h"

@implementation SPMessageModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _messageId = @"";
        _event_id = @"";
        _user_id = @"";
        _reply_id = @"";
        _content = @"";
        _status = @"";
        _time = @"";
        _nick = @"";
    }
    return self;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"messageId":@"id"}];
}

@end
