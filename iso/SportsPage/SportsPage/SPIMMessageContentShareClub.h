//
//  SPIMMessageContentShareClub.h
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCShareClubMessageTypeIdentifier @"SP:ClubShare"

@interface SPIMMessageContentShareClub : RCMessageContent <NSCoding>

@property (nonatomic,strong) NSString *clubId;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) NSString *content;

+ (instancetype)messageWithContent:(NSString *)content;

@end
