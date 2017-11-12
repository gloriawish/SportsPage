//
//  SPIMDataSource.m
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMDataSource.h"

#import "SPIMBusinessUnit.h"

#import "SPGroupModel.h"

#import "AppDelegate.h"

#import <AudioToolbox/AudioToolbox.h>
#import "SPPlaySoundSingleton.h"

#import "SPIMViewController.h"

@implementation SPIMDataSource

#pragma mark - Singleton
static SPIMDataSource *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+ (instancetype)shareInstance {
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    NSLog(@"userId:%@",userId);
    if (userId == nil || userId.length == 0) {
        completion(nil);
        return;
    } else {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableArray *tempFriendListArray = delegate.friendsListArray;
        
        for (SPUserInfoModel *userModel in tempFriendListArray) {
            if ([userModel.userId isEqualToString:userId]) {
                RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                userInfo.userId = userId;
                userInfo.name = [userModel nick];
                userInfo.portraitUri = [userModel portrait];
                completion(userInfo);
                return;
            }
        }
        
        //缓存中未搜索到好友,网络请求好友信息
        NSString *selfUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        if ([userId isEqualToString:selfUserId]) {
            [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:userId success:^(JSONModel *model) {
                if (model) {
                    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                    userInfo.userId = userId;
                    userInfo.name = [(SPUserInfoModel *)model nick];
                    userInfo.portraitUri = [(SPUserInfoModel *)model portrait];
                    completion(userInfo);
                } else {
                    completion(nil);
                }
            } failure:^(NSString *errorString) {
                NSLog(@"网络获取失败");
                completion(nil);
            }];
        } else {
            [[SPIMBusinessUnit shareInstance] getFriendsListWithUserId:selfUserId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
                for (SPUserInfoModel *userModel in friendsList) {
                    if ([userModel.userId isEqualToString:userId]) {
                        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                        userInfo.userId = userId;
                        userInfo.name = [userModel nick];
                        userInfo.portraitUri = [userModel portrait];
                        completion(userInfo);
                    }
                }
            } failure:^(NSString *errorString) {
                NSLog(@"网络获取失败");
                completion(nil);
            }];
        }
    }
}

#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion {
    NSLog(@"groupId:%@",groupId);
    if (groupId.length == 0) {
        return;
    } else {
        [[SPIMBusinessUnit shareInstance] getGroupInfoWithGroupId:groupId successful:^(JSONModel *model) {
            RCGroup *groupInfo = [[RCGroup alloc] init];
            groupInfo.groupId = [(SPGroupModel *)model groupId];
            groupInfo.groupName = [(SPGroupModel *)model name];
            groupInfo.portraitUri = [(SPGroupModel *)model portrait];
            completion(groupInfo);
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
        }];
    }
}

#pragma mark - RCIMGroupUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId
                      inGroup:(NSString *)groupId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
    [[SPIMBusinessUnit shareInstance] getUserInfoWithUserId:userId success:^(JSONModel *model) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = [(SPUserInfoModel *)model nick];
        userInfo.portraitUri = [(SPUserInfoModel *)model portrait];
        completion(userInfo);
    } failure:^(NSString *errorString) {
        NSLog(@"%@",errorString);
    }];
}

#pragma mark - RCIMConnectionStatusDelegate

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        //当前用户在其他设备上登录，此设备被踢下线
        NSLog(@"当前用户在其他设备上登录,此设备被踢下线");
        //跳出登陆界面
#warning 用户被强制下线 跳出登录界面 TODO
        
    } else if (status == ConnectionStatus_Connecting) {
        //连接中n
        
    } else if (status == ConnectionStatus_Unconnected) {
        //连接失败或未连接
        
    } else if (status == ConnectionStatus_SignUp) {
        //已注销
        
    }
}


#pragma mark - RCIMReceiveMessageDelegate
//在前台和后台活动状态时受到任何消息都会执行
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:message.conversationType targetId:message.targetId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == DO_NOT_DISTURB) {
            //NSLog(@"状态为消息免打扰,不发送振动");
        } else if (nStatus == NOTIFY) {
            //NSLog(@"状态非消息免打扰,发送振动");
            NSInteger playAlert = [[NSUserDefaults standardUserDefaults] integerForKey:@"playAlert"];
            if (playAlert == 0 || playAlert == 2) {
                SPPlaySoundSingleton *soundSingleton = [[SPPlaySoundSingleton alloc] initForPlayingVibrate];
                [soundSingleton play];
            }
        }
    } error:^(RCErrorCode status) {
        NSLog(@"onRCIMReceiveMessage,查询消息免打扰失败");
    }];
    
}

//- (BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName {
//    NSLog(@"%@",message);
//    NSLog(@"%@",senderName);
//    return true;
//}

//在后台活动状态时接收到消息会执行
//-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName {
//    return false;
//}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
