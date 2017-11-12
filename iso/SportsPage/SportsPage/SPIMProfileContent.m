//
//  SPIMProfileContent.m
//  SportsPage
//
//  Created by Qin on 2016/12/26.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMProfileContent.h"

@implementation SPIMProfileContent

+ (instancetype)messageWithContent:(NSString *)content {
    SPIMProfileContent *msg = [[SPIMProfileContent alloc] init];
    if (msg) {
        //msg.content = content;
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
        self.operation = [aDecoder decodeObjectForKey:@"operation"];
        self.data = [aDecoder decodeObjectForKey:@"data"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.operation forKey:@"operation"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

#pragma mark – RCMessageCoding delegate methods
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.operation forKey:@"operation"];
    if (self.data) {
        [dataDict setObject:self.data forKey:@"data"];
    }
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
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
            self.operation = dictionary[@"operation"];
            self.data = dictionary[@"data"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

+ (NSString *)getObjectName {
    return RCExitGroupTypeIdentifier;
}

/// 会话列表中显示的摘要
#pragma mark - RCMessageContentView
- (NSString *)conversationDigest {
    return @"群解散消息";
}

@end
