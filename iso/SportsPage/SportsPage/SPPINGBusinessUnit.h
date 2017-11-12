//
//  SPPINGBusinessUnit.h
//  SportsPage
//
//  Created by Qin on 2016/10/25.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"

typedef void(^PINGStringSuccessBlock)(NSString *successfulString);

typedef void(^PINGSuccessBlock)(NSDictionary *dic);
typedef void(^PINGFailureBlock)(NSString *errorString);

typedef void(^PINGModelSuccessfulBlock)(NSString *successsfulString,JSONModel *jsonModel);

@interface SPPINGBusinessUnit : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

#pragma mark - Order
#pragma mark 获取用户所有的记录
- (void)getMineOrdersWithUserId:(NSString *)userId
                         offset:(NSString *)offset
                           size:(NSString *)size
                     successful:(PINGModelSuccessfulBlock)successful
                        failure:(PINGFailureBlock)failure;

#pragma mark 获取在进行中的记录
- (void)getOrdersIngWithUserId:(NSString *)userId
                        offset:(NSString *)offset
                          size:(NSString *)size
                    successful:(PINGModelSuccessfulBlock)successful
                       failure:(PINGFailureBlock)failure;

#pragma mark 获取待结算的记录
- (void)getOrdersSettlementWithUserId:(NSString *)userId
                               offset:(NSString *)offset
                                 size:(NSString *)size
                           successful:(PINGModelSuccessfulBlock)successful
                              failure:(PINGFailureBlock)failure;

#pragma mark 获取待评价的记录
- (void)getOrdersAppraiseWithUserId:(NSString *)userId
                             offset:(NSString *)offset
                               size:(NSString *)size
                         successful:(PINGModelSuccessfulBlock)successful
                            failure:(PINGFailureBlock)failure;

#pragma mark 账户支付报名费用
- (void)orderPaymentWithUserId:(NSString *)userId
                       orderNo:(NSString *)orderNo
                       paypass:(NSString *)paypass
                    successful:(PINGStringSuccessBlock)successful
                       failure:(PINGFailureBlock)failure;

#pragma mark - Payment

#pragma mark - PING
#pragma mark 获取一个支付凭证
- (void)getPayChargeWithUserId:(NSString *)userId
                        amount:(NSString *)amount
                       channel:(NSString *)channel
                       subject:(NSString *)subject
                    successful:(PINGSuccessBlock)successful
                       failure:(PINGFailureBlock)failure;

#pragma mark 获取某个订单的支付凭证
- (void)getPaymentChargeWithchannel:(NSString *)channel
                            orderNo:(NSString *)orderNo
                         successful:(PINGSuccessBlock)successful
                            failure:(PINGFailureBlock)failure;

#pragma mark - Wallet
#pragma mark 获取账户信息
- (void)getAccountInfoWithUserId:(NSString *)userId
                      successful:(PINGSuccessBlock)successful
                         failure:(PINGFailureBlock)failure;

#pragma mark 更新支付密码
- (void)updatePaypassWithUserId:(NSString *)userId
                         mobile:(NSString *)mobile
                       password:(NSString *)password
                         verify:(NSString *)verify
                     successful:(PINGStringSuccessBlock)successful
                        failure:(PINGFailureBlock)failure;

#pragma mark 获取记账信息
- (void)getDaybooksWithUserId:(NSString *)userId
                   successful:(PINGModelSuccessfulBlock)successful
                      failure:(PINGFailureBlock)failure;

#pragma mark 提现申请
- (void)submitWithdrawWithUserId:(NSString *)userId
                         account:(NSString *)account
                            name:(NSString *)name
                          amount:(NSString *)amount
                      successful:(PINGStringSuccessBlock)successful
                         failure:(PINGFailureBlock)failure;

@end
