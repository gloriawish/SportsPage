//
//  SPAuthBusinessUnit.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPUserInfoModel.h"

typedef void(^AuthSuccessfulBlock)(NSString *successsfulString);
typedef void(^AuthLoginSuccessfulBlock)(SPUserInfoModel *model);
typedef void(^AuthFailureBlock)(NSString *errorString);

@interface SPAuthBusinessUnit : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

- (void)getGlobalConfSuccessful:(AuthSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure;

#pragma mark - Auth
#pragma mark 提交授权数据
- (void)addWxclientWithJsonStr:(NSString *)json
                        openid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure;

#pragma mark 提交授权数据
- (void)addQQclientWithJsonStr:(NSString *)json
                        openid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure;

#pragma mark 检查微信是否注册
- (void)checkWxRegisterWithOpenid:(NSString *)openid
                       successful:(AuthSuccessfulBlock)successful
                          failure:(AuthFailureBlock)failure;

#pragma mark 检查QQ是否注册
- (void)checkQQRegisterWithOpenid:(NSString *)openid
                       successful:(AuthSuccessfulBlock)successful
                          failure:(AuthFailureBlock)failure;

#pragma mark 通过手机注册账号
- (void)registerWithMobile:(NSString *)mobile
                      nick:(NSString *)nick
                  password:(NSString *)password
                    verify:(NSString *)verify
                successful:(AuthSuccessfulBlock)successful
                   failure:(AuthFailureBlock)failure;

#pragma mark 通过微信注册账号
- (void)registerWithWeChatByUnionId:(NSString *)unionid
                             openid:(NSString *)openid
                         successful:(AuthSuccessfulBlock)successful
                            failure:(AuthFailureBlock)failure;

#pragma mark 通过QQ注册账号
- (void)registerWithQQByOpenid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure;

#pragma mark 通过手机登陆
- (void)loginWithMobileByMobile:(NSString *)mobile
                       password:(NSString *)password
                     successful:(AuthLoginSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure;

#pragma mark 通过微信登陆
- (void)loginWithWeChatByOpenid:(NSString *)openid
                     successful:(AuthLoginSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure;

#pragma mark 通过QQ登陆
- (void)loginWithQQByOpenid:(NSString *)openid
                 successful:(AuthLoginSuccessfulBlock)successful
                    failure:(AuthFailureBlock)failure;

#pragma mark 找回密码
- (void)resetPasswordWithMobile:(NSString *)mobile
                       password:(NSString *)password
                         verify:(NSString *)verify
                     successful:(AuthSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure;

#pragma mark - SMS
#pragma mark 通过手机号获取验证码
- (void)getVerifyWithMobile:(NSString *)mobile
                 successful:(AuthSuccessfulBlock)successful
                    failure:(AuthFailureBlock)failure;

@end
