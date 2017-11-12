//
//  SPIMMessageContentShareClub.m
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPIMMessageContentShareClub.h"
#import <RongIMLib/RCUtilities.h>

@implementation SPIMMessageContentShareClub

+ (instancetype)messageWithContent:(NSString *)content {
    SPIMMessageContentShareClub *msg = [[SPIMMessageContentShareClub alloc] init];
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
        self.shareTitle = [aDecoder decodeObjectForKey:@"shareTitle"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.clubId = [aDecoder decodeObjectForKey:@"clubId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.shareTitle forKey:@"shareTitle"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.clubId forKey:@"clubId"];
}

#pragma mark – RCMessageCoding delegate methods
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.shareTitle) {
        [dataDict setObject:self.shareTitle forKey:@"shareTitle"];
    }
    if (self.imageUrl) {
        [dataDict setObject:self.imageUrl forKey:@"imageUrl"];
    }
    if (self.clubId) {
        [dataDict setObject:self.clubId forKey:@"clubId"];
    }
    
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
            self.imageUrl = dictionary[@"imageUrl"];
            self.shareTitle = dictionary[@"shareTitle"];
            self.clubId = dictionary[@"clubId"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

+ (NSString *)getObjectName {
    return RCShareClubMessageTypeIdentifier;
}

/// 会话列表中显示的摘要
#pragma mark - RCMessageContentView
- (NSString *)conversationDigest {
    return @"一条俱乐部的分享";
}

@end
