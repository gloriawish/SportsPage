//
//  SPIMMessageContentInviteClub.m
//  SportsPage
//
//  Created by Qin on 2017/4/5.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMMessageContentInviteClub.h"

@implementation SPIMMessageContentInviteClub

+ (instancetype)messageWithContent:(NSString *)content {
    SPIMMessageContentInviteClub *msg = [[SPIMMessageContentInviteClub alloc] init];
    if (msg) {
        msg.content = content;
    }
    return msg;
}

#pragma mark - RCMessagePersistentCompatible
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
}

#pragma mark – RCMessageCoding delegate methods
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.content = dictionary[@"content"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

+ (NSString *)getObjectName {
    return RCInviteClubMessageTypeIdentifier;
}

/// 会话列表中显示的摘要
#pragma mark - RCMessageContentView
- (NSString *)conversationDigest {
    return @"来自俱乐部的邀请";
}

@end
