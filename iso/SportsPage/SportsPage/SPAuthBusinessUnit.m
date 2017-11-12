//
//  SPAuthBusinessUnit.m
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPAuthBusinessUnit.h"
#import "AFNetworking.h"
#import "NSString+Encrypt.h"

#import "SPUserInfoModel.h"

@implementation SPAuthBusinessUnit

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
static SPAuthBusinessUnit *_instance;

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

- (void)getGlobalConfSuccessful:(AuthSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    [manager GET:[SPPathConfig getGlobalConf] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(responseObject[@"result"][@"money_display"]);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - Auth
#pragma mark 提交授权数据
- (void)addWxclientWithJsonStr:(NSString *)json
                        openid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"json":json,@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig addWxclient] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"addWxclient,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else {
            NSString *retString = [NSString stringWithFormat:@"addWxclient,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            successful(retString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 提交授权数据
- (void)addQQclientWithJsonStr:(NSString *)json
                        openid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"json":json,@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig addQQclient] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"addQQclient,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else {
            NSString *retString = [NSString stringWithFormat:@"addQQclient,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            successful(retString);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark 检查微信是否注册
- (void)checkWxRegisterWithOpenid:(NSString *)openid
                       successful:(AuthSuccessfulBlock)successful
                          failure:(AuthFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    NSLog(@"param:%@",param);
    
    [manager GET:[SPPathConfig checkWxRegister] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"checkWxRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            NSString *retString = [NSString stringWithFormat:@"checkWxRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"600");
        } else {
            NSString *retString = [NSString stringWithFormat:@"checkWxRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            successful(retString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 检查QQ是否注册
- (void)checkQQRegisterWithOpenid:(NSString *)openid
                       successful:(AuthSuccessfulBlock)successful
                          failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig checkQQRegister] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"checkQQRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            NSString *retString = [NSString stringWithFormat:@"checkQQRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"600");
        } else {
            NSString *retString = [NSString stringWithFormat:@"checkQQRegister,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            successful(retString);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failure(error.localizedDescription);
    }];
    
}

#pragma mark 通过手机注册账号
- (void)registerWithMobile:(NSString *)mobile
                      nick:(NSString *)nick
                  password:(NSString *)password
                    verify:(NSString *)verify
                successful:(AuthSuccessfulBlock)successful
                   failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = nil;
    if (nick.length == 0 || !nick) {
        tempParam = @{@"mobile":mobile,
                      @"password":password,
                      @"verify":verify};
    } else {
        tempParam = @{@"mobile":mobile,
                      @"nick":nick,
                      @"password":password,
                      @"verify":verify};
    }
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig registerWithMobile] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"registerWithMobile,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            NSString *retString = [NSString stringWithFormat:@"registerWithMobile,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"600");
        } else {
            NSString *retString = [NSString stringWithFormat:@"registerWithMobile,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            successful(retString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 通过微信注册账号
- (void)registerWithWeChatByUnionId:(NSString *)unionid
                             openid:(NSString *)openid
                         successful:(AuthSuccessfulBlock)successful
                            failure:(AuthFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"unionid":unionid,@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig registerByWeinxin] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"registerWithWeChat,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            NSString *retString = [NSString stringWithFormat:@"registerWithWeChat,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"600");
        } else {
            NSString *retString = [NSString stringWithFormat:@"registerWithWeChat,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(retString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 通过QQ注册账号
- (void)registerWithQQByOpenid:(NSString *)openid
                    successful:(AuthSuccessfulBlock)successful
                       failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig registerByQQ] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSString *retString = [NSString stringWithFormat:@"registerWithQQ,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"200");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            NSString *retString = [NSString stringWithFormat:@"registerWithQQ,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(@"600");
        } else {
            NSString *retString = [NSString stringWithFormat:@"registerWithQQ,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(retString);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 通过手机登陆
- (void)loginWithMobileByMobile:(NSString *)mobile
                       password:(NSString *)password
                     successful:(AuthLoginSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"mobile":mobile,@"password":password};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig loginWithMobile] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error;
            SPUserInfoModel *model = [[SPUserInfoModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(model);
            } else {
                NSLog(@"jsonToModelError:%@",error.localizedDescription);
                successful(nil);
            }
            
        } else {
            NSString *retString = [NSString stringWithFormat:@"loginWithMobileByMobile,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
    
}

#pragma mark 通过微信登陆
- (void)loginWithWeChatByOpenid:(NSString *)openid
                     successful:(AuthLoginSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig loginWithWeixin] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            SPUserInfoModel *model = [[SPUserInfoModel alloc] initWithDictionary:responseObject[@"result"] error:nil];
            successful(model);
        } else {
            NSString *retString = [NSString stringWithFormat:@"loginWithWeChatByOpenid,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 通过QQ登陆
- (void)loginWithQQByOpenid:(NSString *)openid
                 successful:(AuthLoginSuccessfulBlock)successful
                    failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"openid":openid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig loginWithQQ] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            SPUserInfoModel *model = [[SPUserInfoModel alloc] initWithDictionary:responseObject[@"result"] error:nil];
            successful(model);
        } else {
            NSString *retString = [NSString stringWithFormat:@"loginWithQQByOpenid,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 找回密码
- (void)resetPasswordWithMobile:(NSString *)mobile
                       password:(NSString *)password
                         verify:(NSString *)verify
                     successful:(AuthSuccessfulBlock)successful
                        failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"mobile":mobile,@"password":password,@"verify":verify};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig resetPassword] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"invalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            NSString *retString = [NSString stringWithFormat:@"resetPasswordWithMobile,code:%@,result:%@,error:%@",
                                   [responseObject[@"code"] stringValue],responseObject[@"result"],responseObject[@"error"]];
            NSLog(@"%@",retString);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}


#pragma mark - SMS
#pragma mark 通过手机号获取验证码
- (void)getVerifyWithMobile:(NSString *)mobile
                 successful:(AuthSuccessfulBlock)successful
                    failure:(AuthFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPAuthBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"mobile":mobile};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
 
    [manager GET:[SPPathConfig getVerifyWithMobile] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else {
            NSLog(@"%@",responseObject);
            successful([responseObject[@"code"] stringValue]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

@end
