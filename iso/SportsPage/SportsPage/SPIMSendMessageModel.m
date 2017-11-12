//
//  SPIMSendMessageModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMSendMessageModel.h"

@implementation SPIMSendMessageModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _eventId = @"";
        _imageUrl = @"";
        _shareTitle = @"";
        _content = @"";
    }
    return self;
}

@end
