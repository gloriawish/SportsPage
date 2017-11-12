//
//  SPUserBusinessUnit.m
//  SportsPage
//
//  Created by Qin on 2016/10/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPUserBusinessUnit.h"

#import "AFNetworking.h"
#import "NSString+Encrypt.h"

#import "SPPersonalInfoModel.h"
#import "SPSportsNotificationResponseModel.h"

@implementation SPUserBusinessUnit

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
static SPUserBusinessUnit *_instance;

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

#pragma mark - User
#pragma mark 绑定手机
- (void)bindMobileWithUserId:(NSString *)userId
                      mobile:(NSString *)mobile
                      verify:(NSString *)verify
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"mobile":mobile,@"verify":verify};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig bindMobile] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful([NSString stringWithFormat:@"%@",responseObject[@"error"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 绑定微信
- (void)bindWexinWithUserId:(NSString *)userId
                     openId:(NSString *)openid
                    unionid:(NSString *)unionid
                 successful:(UserSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"openid":openid,@"unionid":unionid};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    [manager POST:[SPPathConfig bindWexin] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful([NSString stringWithFormat:@"%@",responseObject[@"error"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取用户相关的信息
- (void)getMineInfoWithUserId:(NSString *)userId
                   successful:(UserModelSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getMineInfo] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            SPPersonalInfoModel *personalInfoModel = [[SPPersonalInfoModel alloc] initWithDictionary:responseObject[@"result"] error:nil];
            successful(@"successful",personalInfoModel);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful([NSString stringWithFormat:@"%@",responseObject[@"error"]],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 实名认证
- (void)realNameCheckWithUserId:(NSString *)userId
                         images:(NSArray *)imageArray
                     successful:(UserSuccessfulBlock)successful
                        failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig realNameCheck] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in imageArray) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSString *fileName = [NSString stringWithFormat:@"%ld_%@.jpg",(long)[[NSDate date] timeIntervalSince1970],userId];
            [formData appendPartWithFileData:imageData name:@"files[]" fileName:fileName mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 更新城市
- (void)updateCityWithUserId:(NSString *)userId
                        city:(NSString *)city
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"city":city};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateCity] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 更新邮箱
- (void)updateEmailWithUserId:(NSString *)userId
                        email:(NSString *)email
                   successful:(UserSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"email":email};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateEmail] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 更新昵称
- (void)updateNickWithUserId:(NSString *)userId
                   nickName:(NSString *)nickName
                  successful:(UserSuccessfulBlock)successful
                     failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"nickName":nickName};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateNick] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 更新头像
- (void)updatePortraitWithUserId:(NSString *)userId
                           image:(UIImage *)image
                      successful:(UserSuccessfulBlock)successful
                         failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updatePortrait] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
        NSString *fileName = [NSString stringWithFormat:@"%ld_%@.jpg",(long)[[NSDate date] timeIntervalSince1970],userId];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 更新性别
- (void)updateSexWithUserId:(NSString *)userId
                        sex:(NSString *)sex
                 successful:(UserSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"sex":sex};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateSex] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark 意见反馈
- (void)addFeedbackWithUserId:(NSString *)userId
                      content:(NSString *)content
                   successful:(UserSuccessfulBlock)successful
                      failure:(UserFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"content":content,@"type":@"iOS"};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig addfeedback] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
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

#pragma mark - Notify
#pragma mark 获取系统提示信息
- (void)getNotifyWithUserId:(NSString *)userId
                       type:(NSString *)type
                     offset:(NSString *)offset
                       size:(NSString *)size
                 successful:(UserModelSuccessfulBlock)successful
                    failure:(UserFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"type":type,
                                @"offset":offset,
                                @"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getNotify] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsNotificationResponseModel *model = [[SPSportsNotificationResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"JSONModel Error:%@",error.localizedDescription);
                successful(@"JSONModel Error",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"getNotify:%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark - Push
#pragma mark 注册推送服务
- (void)regPushServiceWithUserId:(NSString *)userId
                             cid:(NSString *)cid
                        platform:(NSString *)platform
                      successful:(UserSuccessfulBlock)successful
                         failure:(UserFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPUserBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"cid":cid,
                                @"platform":@"iOS"};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    NSLog(@"regPushService param:%@",param);
    
    [manager POST:[SPPathConfig regPushService] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful([NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

@end
