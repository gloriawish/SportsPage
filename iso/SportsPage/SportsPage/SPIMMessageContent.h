//
//  SPIMMessageContent.h
//  SportsPage
//
//  Created by Qin on 2016/12/12.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCShareMessageTypeIdentifier @"SP:EventShare"

@interface SPIMMessageContent : RCMessageContent <NSCoding>

//@property (nonatomic,strong) NSString *extra;
@property (nonatomic,strong) NSString *eventId;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) NSString *content;

+ (instancetype)messageWithContent:(NSString *)content;

@end
