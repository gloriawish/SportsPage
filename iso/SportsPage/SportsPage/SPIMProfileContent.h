//
//  SPIMProfileContent.h
//  SportsPage
//
//  Created by Qin on 2016/12/26.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCExitGroupTypeIdentifier @"SP:Profile"

@interface SPIMProfileContent : RCMessageContent <NSCoding>

@property (nonatomic,strong) NSString *operation;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *extra;

+ (instancetype)messageWithContent:(NSString *)content;

@end
