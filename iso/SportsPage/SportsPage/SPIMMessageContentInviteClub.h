//
//  SPIMMessageContentInviteClub.h
//  SportsPage
//
//  Created by Qin on 2017/4/5.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCInviteClubMessageTypeIdentifier @"SP:ClubInvite"

@interface SPIMMessageContentInviteClub : RCMessageContent

@property (nonatomic,strong) NSString *content;

+ (instancetype)messageWithContent:(NSString *)content;

@end
