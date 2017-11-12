//
//  SPPINGBusinessUnit.m
//  SportsPage
//
//  Created by Qin on 2016/10/25.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPINGBusinessUnit.h"

#import "SPPersonalEventResponseModel.h"
#import "SPPersonalAccountDefiniteResponseModel.h"

#import "AFNetworking.h"
#import "NSString+Encrypt.h"

@implementation SPPINGBusinessUnit

#pragma mark - AFNetworkingLeaksSolution
+ (AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer.timeoutInterval = 10;
        NSMutableSet *acceptableSet = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
        [acceptableSet addObject:CONTENTTYPE];
        manager.responseSerializer.acceptableContentTypes = acceptableSet;
    });
    return manager;
}

#pragma mark - Singleton
static SPPINGBusinessUnit *_instance;

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

#pragma mark - Sign
+ (NSString *)getSignature:(NSDictionary *)parameters secret:(NSString *)secret {
    NSMutableString *baseString = [[NSMutableString alloc] init];
    NSArray *sortArray = [parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for(NSString *key in sortArray) {
        NSString *value = [parameters objectForKey:key];
        [baseString appendFormat:@"%@=%@&", key, value];
    }
    NSRange deleteRange = {[baseString length] - 1, 1};
    [baseString deleteCharactersInRange:deleteRange];
    [baseString appendString:secret];
    return [baseString MD5];
}

- (NSDictionary *)getParamWithDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        NSString *signString = [[self class] getSignature:dictionary secret:@"www.sportspage.cn"];
        [muDic setObject:signString forKey:@"sign"];
        return [muDic copy];
    } else {
        return @{@"sign":[@"www.sportspage.cn" MD5]};
    }
}

#pragma mark - Order
#pragma mark 获取用户所有的记录
- (void)getMineOrdersWithUserId:(NSString *)userId
                         offset:(NSString *)offset
                           size:(NSString *)size
                     successful:(PINGModelSuccessfulBlock)successful
                        failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getMineOrders] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSError *error = nil;
            SPPersonalEventResponseModel *model = [[SPPersonalEventResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"error:%@",error.localizedDescription);
                successful(@"JSONModel Error",nil);
            }
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"500"]) {
            successful(@"InvalidRequest",nil);
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"1000"]) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取在进行中的记录
- (void)getOrdersIngWithUserId:(NSString *)userId
                        offset:(NSString *)offset
                          size:(NSString *)size
                    successful:(PINGModelSuccessfulBlock)successful
                       failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getOrdersIng] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSError *error = nil;
            SPPersonalEventResponseModel *model = [[SPPersonalEventResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"error:%@",error.localizedDescription);
                successful(@"JSONModel Error",nil);
            }
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"500"]) {
            successful(@"InvalidRequest",nil);
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"1000"]) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取待结算的记录
- (void)getOrdersSettlementWithUserId:(NSString *)userId
                               offset:(NSString *)offset
                                 size:(NSString *)size
                           successful:(PINGModelSuccessfulBlock)successful
                              failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getOrdersSettlement] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSError *error = nil;
            SPPersonalEventResponseModel *model = [[SPPersonalEventResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"error:%@",error.localizedDescription);
                successful(@"JSONModel Error",nil);
            }
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"500"]) {
            successful(@"InvalidRequest",nil);
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"1000"]) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取待评价的记录
- (void)getOrdersAppraiseWithUserId:(NSString *)userId
                             offset:(NSString *)offset
                               size:(NSString *)size
                         successful:(PINGModelSuccessfulBlock)successful
                            failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getOrdersAppraise] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            NSError *error = nil;
            SPPersonalEventResponseModel *model = [[SPPersonalEventResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"error:%@",error.localizedDescription);
                successful(@"JSONModel Error",nil);
            }
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"500"]) {
            successful(@"InvalidRequest",nil);
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"1000"]) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 账户支付报名费用
- (void)orderPaymentWithUserId:(NSString *)userId
                       orderNo:(NSString *)orderNo
                       paypass:(NSString *)paypass
                    successful:(PINGStringSuccessBlock)successful
                       failure:(PINGFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"orderNo":orderNo,@"paypass":paypass};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig orderPayment] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            successful(@"successful");
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"500"]) {
            successful(@"InvalidRequest");
        } else if ([[responseObject[@"code"] stringValue] isEqualToString:@"1000"]) {
            successful(@"signError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark - Payment

#pragma mark - PING
#pragma mark 获取一个支付凭证
- (void)getPayChargeWithUserId:(NSString *)userId
                        amount:(NSString *)amount
                       channel:(NSString *)channel
                       subject:(NSString *)subject
                    successful:(PINGSuccessBlock)successful
                       failure:(PINGFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"amount":amount,
                                @"channel":channel,
                                @"subject":subject};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getPayCharge] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(responseObject);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            NSLog(@"InvalidRequest");
            successful(nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            NSLog(@"signError");
            successful(nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取某个订单的支付凭证
- (void)getPaymentChargeWithchannel:(NSString *)channel
                            orderNo:(NSString *)orderNo
                         successful:(PINGSuccessBlock)successful
                            failure:(PINGFailureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"channel":channel,@"orderNo":orderNo};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getPaymentCharge] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(responseObject);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            NSLog(@"InvalidRequest");
            successful(nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            NSLog(@"signError");
            successful(nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
    
}

#pragma mark - Wallet
#pragma mark 获取账户信息
- (void)getAccountInfoWithUserId:(NSString *)userId
                      successful:(PINGSuccessBlock)successful
                         failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getAccountInfo] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(responseObject[@"result"]);
        } else {
            NSLog(@"getAccountInfo,%@",[NSString stringWithFormat:@"%@,%@,%@",
                                       responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 修改支付密码
- (void)updatePaypassWithUserId:(NSString *)userId
                         mobile:(NSString *)mobile
                       password:(NSString *)password
                         verify:(NSString *)verify
                     successful:(PINGStringSuccessBlock)successful
                        failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"mobile":mobile,@"password":password,@"verify":verify};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updatePaypass] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            NSLog(@"updatePaypass,%@",[NSString stringWithFormat:@"%@,%@,%@",
                         responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取记账信息
- (void)getDaybooksWithUserId:(NSString *)userId
                   successful:(PINGModelSuccessfulBlock)successful
                      failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getDaybooks] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPPersonalAccountDefiniteResponseModel *model = [[SPPersonalAccountDefiniteResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"JSONModel Error:%@",error.localizedDescription);
                successful(@"JSONModelERROR",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 提现申请
- (void)submitWithdrawWithUserId:(NSString *)userId
                         account:(NSString *)account
                            name:(NSString *)name
                          amount:(NSString *)amount
                      successful:(PINGStringSuccessBlock)successful
                         failure:(PINGFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPPINGBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"account":account,@"name":name,@"amount":amount};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig submitWithdraw] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}


@end
