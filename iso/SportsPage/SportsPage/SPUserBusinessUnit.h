//
//  SPUserBusinessUnit.h
//  SportsPage
//
//  Created by Qin on 2016/10/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

typedef void(^UserSuccessfulBlock)(NSString *successsfulString);
typedef void(^UserFailureBlock)(NSString *errorString);
typedef void(^UserModelSuccessfulBlock)(NSString *successsfulString,JSONModel *model);

@interface SPUserBusinessUnit : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

#pragma mark - User
#pragma mark 绑定手机
- (void)bindMobileWithUserId:(NSString *)userId
                      mobile:(NSString *)mobile
                      verify:(NSString *)verify
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure;

#pragma mark 绑定微信
- (void)bindWexinWithUserId:(NSString *)userId
                     openId:(NSString *)openid
                    unionid:(NSString *)unionid
                 successful:(UserSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure;

#pragma mark 获取用户相关的信息
- (void)getMineInfoWithUserId:(NSString *)userId
                   successful:(UserModelSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure;

#pragma mark 实名认证
- (void)realNameCheckWithUserId:(NSString *)userId
                         images:(NSArray *)imageArray
                     successful:(UserSuccessfulBlock)successful
                        failure:(UserFailureBlock)failure;

#pragma mark 更新城市
- (void)updateCityWithUserId:(NSString *)userId
                        city:(NSString *)city
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure;

#pragma mark 更新邮箱
- (void)updateEmailWithUserId:(NSString *)userId
                        email:(NSString *)email
                   successful:(UserSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure;

#pragma mark 更新昵称
- (void)updateNickWithUserId:(NSString *)userId
                   nickName:(NSString *)nickeName
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure;

#pragma mark 更新头像
- (void)updatePortraitWithUserId:(NSString *)userId
                           image:(UIImage *)image
                      successful:(UserSuccessfulBlock)successful
                         failure:(UserFailureBlock)failure;

#pragma mark 更新性别
- (void)updateSexWithUserId:(NSString *)userId
                        sex:(NSString *)sex
                 successful:(UserSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure;

#pragma mark 意见反馈
- (void)addFeedbackWithUserId:(NSString *)userId
                      content:(NSString *)content
                   successful:(UserSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure;


#pragma mark - Notify
#pragma mark 获取系统提示信息
- (void)getNotifyWithUserId:(NSString *)userId
                       type:(NSString *)type
                     offset:(NSString *)offset
                       size:(NSString *)size
                 successful:(UserModelSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure;

#pragma mark - Push
#pragma mark 注册推送服务
- (void)regPushServiceWithUserId:(NSString *)userId
                             cid:(NSString *)cid
                        platform:(NSString *)platform
                      successful:(UserSuccessfulBlock)successful
                         failure:(UserFailureBlock)failure;

@end
