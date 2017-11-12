//
//  SPIMBusinessUnit.h
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPAllGroupsModel.h"
#import "SPGroupModel.h"
#import "SPFriendsModel.h"
#import "SPGroupMembersModel.h"
#import "SPMyGroupsModel.h"
#import "SPUserInfoModel.h"

typedef void(^IMSuccessfulBlock)(JSONModel *model);
typedef void(^IMFailureBlock)(NSString *errorString);
typedef void(^IMStringSuccessfulBlock)(NSString *retString);

typedef void(^IMModelSuccessfulBlock)(NSString *successfulString, JSONModel *model);

typedef void(^IMSuccessfulArrayBlock)(NSMutableArray *friendsSortedList, NSMutableArray *friendsList);

@interface SPIMBusinessUnit : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

#pragma mark - IM
#pragma mark - Common
#pragma mark 获取融云的Token
- (void)getIMTokenWithUserId:(NSString *)groupId
                  successful:(IMStringSuccessfulBlock)successful
                     failure:(IMFailureBlock)failure;

#pragma mark 获取用户信息
- (void)getUserInfoWithUserId:(NSString *)userId
                      success:(IMSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure;

#pragma mark 获取用户信息(判断是否为好友关系)
- (void)getUserInfoByRelationWithUserId:(NSString *)userId
                               targetId:(NSString *)targetId
                                success:(IMSuccessfulBlock)successful
                                failure:(IMFailureBlock)failure;

#pragma mark - 好友
#pragma mark 添加好友
- (void)addFriendWithUserId:(NSString *)userId
                   friendId:(NSString *)friendId
                    message:(NSString *)message
                      extra:(NSString *)extra
                 successful:(IMStringSuccessfulBlock)successful
                    failure:(IMFailureBlock)failure;

#pragma mark 删除好友
- (void)deleteFriendWithUserId:(NSString *)userId
                      friendId:(NSString *)friendId
                    successful:(IMStringSuccessfulBlock)successful
                       failure:(IMFailureBlock)failure;

#pragma mark 批量添加好友
- (void)addFriendBatchWithUserId:(NSString *)userId
                       friendIds:(NSString *)friendId
                         message:(NSString *)message
                           extra:(NSString *)extra
                      successful:(IMStringSuccessfulBlock)successful
                         failure:(IMFailureBlock)failure;

#pragma mark 获取好友列表
- (void)getFriendsListWithUserId:(NSString *)userId
                      successful:(IMSuccessfulArrayBlock)successful
                         failure:(IMFailureBlock)failure;

#pragma mark - 群组
#pragma mark 创建群组
- (void)createGroupWithUserId:(NSString *)userId
                    groupName:(NSString *)groupName
                        intro:(NSString *)intro
                    memberIds:(NSString *)membersIds
                   successful:(IMStringSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure;

#pragma mark 退出群组
- (void)exitGroupWithUserId:(NSString *)userId
                    groupId:(NSString *)groupId
                 successful:(IMStringSuccessfulBlock)successful
                    failure:(IMFailureBlock)failure;

#pragma mark 获取群组信息
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     successful:(IMSuccessfulBlock)successful
                        failure:(IMFailureBlock)failure;

#pragma mark 获取群组成员
- (void)getGroupMembersWithGroupId:(NSString *)groupId
                        successful:(IMModelSuccessfulBlock)successful
                           failure:(IMFailureBlock)failure;

#pragma mark 获取我的群组列表
- (void)getMyGroupsWithUserId:(NSString *)groupId
                   successful:(IMSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure;

#pragma mark 批量加群
- (void)joinGroupBatchWithGroupId:(NSString *)groupId
                          userIds:(NSString *)userIds
                       successful:(IMStringSuccessfulBlock)successful
                          failure:(IMFailureBlock)failure;

#pragma mark - 其他
#pragma mark 处理好友请求
- (void)processRequestFriendWithUserId:(NSString *)userId
                              friendId:(NSString *)friendId
                              isAccess:(NSString *)isAccess
                            successful:(IMStringSuccessfulBlock)successful
                               failure:(IMFailureBlock)failure;

#pragma mark 搜索好友
- (void)searchFriendWithUserId:(NSString *)userId
                     searchKey:(NSString *)searchKey
                    successful:(IMModelSuccessfulBlock)successful
                       failure:(IMFailureBlock)failure;

#pragma mark 发送自定义运动消息
- (void)sendSportIMMessageWithUserId:(NSString *)userId
                                type:(NSString *)type
                            targetId:(NSString *)targetId
                          objectName:(NSString *)objectName
                                json:(NSString *)json
                          successful:(IMStringSuccessfulBlock)successful
                             failure:(IMFailureBlock)failure;

@end
