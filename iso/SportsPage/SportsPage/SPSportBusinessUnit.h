//
//  SPSportBusinessUnit.h
//  SportsPage
//
//  Created by Qin on 2016/10/31.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

typedef void(^SportSuccessfulBlock)(NSString *successsfulString);
typedef void(^SportModelSuccessfulBlock)(NSString *successsfulString,JSONModel *jsonModel);
typedef void(^SportFailureBlock)(NSString *errorString);

typedef void(^SportStringSuccessfulBlock)(NSString *code, NSString *resultString);
typedef void(^SportDicSuccessfulBlock)(NSString *code, NSDictionary *resultDic);

typedef void(^SportClubMembersSuccessfulBlock)(NSMutableArray *adminArray, NSMutableArray *normalMembersArray);
typedef void(^SportClubAddMembersSuccessfulBlock)(NSMutableArray *friendsSortedList, NSMutableArray *friendsList);

@interface SPSportBusinessUnit : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

#pragma mark - Main
#pragma mark 主页热门
- (void)getHotEventWithUserId:(NSString *)userId
                       offset:(NSString *)offset
                         size:(NSString *)size
                     latitude:(NSString *)latitude
                    longitude:(NSString *)longitude
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark 主页关注
- (void)getFollowEventWithUserId:(NSString *)userId
                          offset:(NSString *)offset
                            size:(NSString *)size
                      successful:(SportModelSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 主页根据关键字搜索活动
- (void)searchEventWithUserId:(NSString *)userId
                    searchKey:(NSString *)searchKey
                       offset:(NSString *)offset
                         size:(NSString *)size
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark - Sport
#pragma mark 查询运动页信息
- (void)getSportWithSportId:(NSString *)sportId
                     userId:(NSString *)userId
                 successful:(SportModelSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure;

#pragma mark 获取最近一次激活的活动数据,作为默认数据填充
- (void)getLastEventWithSportId:(NSString *)sportId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark 获取运动详情
- (void)getMineSportWithUserId:(NSString *)userId
                        offset:(NSString *)offset
                          size:(NSString *)size
                    successful:(SportModelSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure;

#pragma mark 关注运动
- (void)followWithUserId:(NSString *)userId
                 sportId:(NSString *)sportId
              successful:(SportSuccessfulBlock)successful
                 failure:(SportFailureBlock)failure;

#pragma mark 取消关注
- (void)cancelFollowWithUserId:(NSString *)userId
                       sportId:(NSString *)sportId
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure;

#pragma mark 获取关注记录
- (void)getFollowsWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                        size:(NSString *)size
                  successful:(SportModelSuccessfulBlock)successful
                     failure:(SportFailureBlock)failure;

#pragma mark 激活运动
- (void)activateSportWithUserId:(NSString *)userId
                        sportId:(NSString *)sportId
                           json:(NSString *)json
                     successful:(SportStringSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark 创建运动
- (void)createSportWithUserId:(NSString *)userId
                         json:(NSString *)json
                        image:(UIImage *)image
                   successful:(SportStringSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark - Event
#pragma mark 发起人解散运动
- (void)dismissEventWithUserId:(NSString *)userId
                       eventId:(NSString *)eventId
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure;

#pragma mark 活动报名
- (void)enrollEventWithUserId:(NSString *)userId
                      eventId:(NSString *)eventId
                   successful:(SportDicSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark 参与人退出运动
- (void)exitEventWithUserId:(NSString *)userId
                    eventId:(NSString *)eventId
                 successful:(SportSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure;

#pragma mark 获取运动详情
- (void)getEventWithEventId:(NSString *)eventId
                     userId:(NSString *)userId
                 successful:(SportModelSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure;

#pragma mark 锁定
- (void)lockWithUserId:(NSString *)userId
               eventId:(NSString *)eventId
            successful:(SportSuccessfulBlock)successful
               failure:(SportFailureBlock)failure;

#pragma mark 解锁
- (void)unlockWithUserId:(NSString *)userId
                 eventId:(NSString *)eventId
              successful:(SportSuccessfulBlock)successful
                 failure:(SportFailureBlock)failure;

- (void)getMessageWithEventId:(NSString *)eventId
                   successful:(SportSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark 评价
- (void)postAppraiseWithUserId:(NSString *)userId
                       eventId:(NSString *)eventId
                         grade:(NSString *)grade
                       content:(NSString *)content
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure;

#pragma mark 结算
- (void)settlementEventWithUserId:(NSString *)userId
                          eventId:(NSString *)eventId
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure;

#pragma mark 发布留言
- (void)postMessageWithUserId:(NSString *)userId
                      eventId:(NSString *)eventId
                      replyId:(NSString *)replyId
                      content:(NSString *)content
                   successful:(SportSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark - Location
- (void)getNearbyEventWithUserId:(NSString *)userId
                        latitude:(NSString *)latitude
                       longitude:(NSString *)longitude
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 根据输入的关键字搜索场地(场馆名 地址名)
- (void)searchPlaceWithUserId:(NSString *)userId
                       search:(NSString *)search
                         city:(NSString *)city
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure;

#pragma mark - Club
#pragma mark 创建俱乐部
- (void)createClubWithUserId:(NSString *)userId
                        name:(NSString *)name
                 description:(NSString *)description
                   sportItem:(NSString *)sportItem
                    capacity:(NSString *)capacity
                        type:(NSString *)type
                      extend:(NSString *)extend
                   iconImage:(UIImage *)iconImage
                  coverImage:(UIImage *)coverImage
                  successful:(SportStringSuccessfulBlock)successful
                     failure:(SportFailureBlock)failure;

#pragma mark 发布公告
- (void)pushPublicNoticeWithUserId:(NSString *)userId
                            clubId:(NSString *)clubId
                           content:(NSString *)content
                        successful:(SportSuccessfulBlock)successful
                           failure:(SportFailureBlock)failure;

#pragma mark 获取俱乐部信息
- (void)getClubDetailWithUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark 获取俱乐部所有成员
- (void)getClubAllMemebersWithClubId:(NSString *)clubId
                          successful:(SportClubMembersSuccessfulBlock)successful
                             failure:(SportFailureBlock)failure;

#pragma mark 批量增加俱乐部成员
- (void)inviteJoinClubWithClubId:(NSString *)clubId
                          userId:(NSString *)userId
                       targetIds:(NSString *)targetIds
                          extend:(NSString *)extend
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 批量删除俱乐部成员
- (void)deleteClubMemberBatchWithClubId:(NSString *)clubId
                                 userId:(NSString *)userId
                              memberIds:(NSString *)memberIds
                             successful:(SportSuccessfulBlock)successful
                                failure:(SportFailureBlock)failure;

#pragma mark 批量增加俱乐部管理员
- (void)setClubAdminBatchWithClubId:(NSString *)clubId
                             userId:(NSString *)userId
                           adminIds:(NSString *)adminIds
                         successful:(SportSuccessfulBlock)successful
                            failure:(SportFailureBlock)failure;

#pragma mark 批量删除俱乐部管理员
- (void)deleteClubAdminBatchWithClubId:(NSString *)clubId
                                userId:(NSString *)userId
                              adminIds:(NSString *)adminIds
                            successful:(SportSuccessfulBlock)successful
                               failure:(SportFailureBlock)failure;

#pragma mark 获取用户所有俱乐部
- (void)getUserClubsWithUserId:(NSString *)userId
                    successful:(SportModelSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure;

#pragma mark 更新加入验证方式
- (void)updateJoinTypeWithUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                        joinType:(NSString *)joinType
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 更新俱乐部封面
- (void)updateClubCoverWithUserId:(NSString *)userId
                           clubId:(NSString *)clubId
                       coverImage:(UIImage *)coverImage
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure;

#pragma mark 更新俱乐部队徽
- (void)updateClubTeamImageWithUserId:(NSString *)userId
                               clubId:(NSString *)clubId
                            teamImage:(UIImage *)teamImage
                           successful:(SportSuccessfulBlock)successful
                              failure:(SportFailureBlock)failure;

#pragma mark 更新俱乐部名称
- (void)updateClubNameWithUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                            name:(NSString *)name
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 更新俱乐部运动项目
- (void)updateClubEventWithUserId:(NSString *)userId
                           clubId:(NSString *)clubId
                        sportItem:(NSString *)sportItem
                  sportItemExtend:(NSString *)sportItemExtend
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure;

#pragma mark 获取俱乐部绑定的运动页
- (void)getClubBindSportsUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark 获取俱乐部绑定的运动页
- (void)getClubUnbindSportUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                      successful:(SportModelSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure;

#pragma mark 俱乐部绑定的运动页
- (void)bindSportToClubBatchWithUserId:(NSString *)userId
                                clubId:(NSString *)clubId
                              sportIds:(NSString *)sportIds
                            successful:(SportSuccessfulBlock)successful
                               failure:(SportFailureBlock)failure;

#pragma mark 获取邀请加入俱乐部请求列表
- (void)getClubInviteListWithUserId:(NSString *)userId
                         successful:(SportModelSuccessfulBlock)successful
                            failure:(SportFailureBlock)failure;

#pragma mark 获取申请加入俱乐部请求列表
- (void)getClubApplyListWithUserId:(NSString *)userId
                        successful:(SportModelSuccessfulBlock)successful
                           failure:(SportFailureBlock)failure;

#pragma mark 同意加入俱乐部的请求 同意申请加入俱乐部
- (void)agreeJoinClubWithUserId:(NSString *)userId
                      requestId:(NSString *)requestId
                     successful:(SportSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark 申请加入俱乐部
- (void)applyJoinClubWithUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                         extend:(NSString *)extend
                     successful:(SportSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure;

#pragma mark - 获取未加入俱乐部的好友
- (void)getNotJoinClubFriendsWithUserId:(NSString *)userId
                                 clubId:(NSString *)clubId
                             successful:(SportClubAddMembersSuccessfulBlock)successful
                                failure:(SportFailureBlock)failure;

@end
