//
//  SPIMSendMessageShareClubModel.m
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMSendMessageShareClubModel.h"

@implementation SPIMSendMessageShareClubModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _clubId = @"";
        _imageUrl = @"";
        _shareTitle = @"";
        _content = @"";
    }
    return self;
}

@end
