//
//  SPSportBusinessUnit.m
//  SportsPage
//
//  Created by Qin on 2016/10/31.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportBusinessUnit.h"

#import "AFNetworking.h"
#import "NSString+Encrypt.h"

#import "SPEventModel.h"
#import "SPSportsMainModel.h"
#import "SPSportsPageBaseModel.h"

#import "SPSportsCreateLocationModel.h"
#import "SPSportsFollowsResponseModel.h"
#import "SPSportsPageResponseModel.h"

#import "SPLastEventModel.h"

#import "SPClubDetailResponseModel.h"

#import "SPClubListResponseModel.h"

#import "SPClubInviteListResponseModel.h"
#import "SPClubApplyListResponseModel.h"

@implementation SPSportBusinessUnit

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
static SPSportBusinessUnit *_instance;

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

#pragma mark - Main
#pragma mark 主页热门
- (void)getHotEventWithUserId:(NSString *)userId
                       offset:(NSString *)offset
                         size:(NSString *)size
                     latitude:(NSString *)latitude
                    longitude:(NSString *)longitude
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size,@"latitude":latitude,@"longitude":longitude};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getHotEvent] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsMainModel *model = [[SPSportsMainModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful(@"JSONModelError",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 主页关注
- (void)getFollowEventWithUserId:(NSString *)userId
                          offset:(NSString *)offset
                            size:(NSString *)size
                      successful:(SportModelSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];

    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getFollowEvent] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsMainModel *model = [[SPSportsMainModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"%@",error.localizedDescription);
                successful(@"JSONModelError",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 主页根据关键字搜索活动
- (void)searchEventWithUserId:(NSString *)userId
                    searchKey:(NSString *)searchKey
                       offset:(NSString *)offset
                         size:(NSString *)size
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"searchKey":searchKey,
                                @"offset":offset,
                                @"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig searchEvent] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsMainModel *model = [[SPSportsMainModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"%@",error.localizedDescription);
                successful(@"JSONModelError",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - Sport
#pragma mark 查询运动页信息
- (void)getSportWithSportId:(NSString *)sportId
                     userId:(NSString *)userId
                 successful:(SportModelSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"sportId":sportId,@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getSport] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsPageBaseModel *model = [[SPSportsPageBaseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful(@"JSONModel Error",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取最近一次激活的活动数据,作为默认数据填充
- (void)getLastEventWithSportId:(NSString *)sportId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"sportId":sportId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getLastEvent] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPLastEventModel *model = [[SPLastEventModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful(@"JSONModel Error",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取运动详情
- (void)getMineSportWithUserId:(NSString *)userId
                        offset:(NSString *)offset
                          size:(NSString *)size
                    successful:(SportModelSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"offset":offset,
                                @"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    [manager GET:[SPPathConfig getMineSport] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsPageResponseModel *model = [[SPSportsPageResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful(@"JSONModel Error",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 关注运动
- (void)followWithUserId:(NSString *)userId
                 sportId:(NSString *)sportId
              successful:(SportSuccessfulBlock)successful
                 failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"sportId":sportId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig follow] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 取消关注
- (void)cancelFollowWithUserId:(NSString *)userId
                       sportId:(NSString *)sportId
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"sportId":sportId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig cancelFollow] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取关注记录
- (void)getFollowsWithUserId:(NSString *)userId
                      offset:(NSString *)offset
                        size:(NSString *)size
                  successful:(SportModelSuccessfulBlock)successful
                     failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"offset":offset,@"size":size};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getFollows] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPSportsFollowsResponseModel *model = [[SPSportsFollowsResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                NSLog(@"JSONModel Error:%@",error.localizedDescription);
                successful(@"JSONModel ERROR",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 激活运动
- (void)activateSportWithUserId:(NSString *)userId
                        sportId:(NSString *)sportId
                           json:(NSString *)json
                     successful:(SportStringSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"sportId":sportId,@"json":json};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig activateSport] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful",responseObject[@"result"]);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 创建运动
- (void)createSportWithUserId:(NSString *)userId
                         json:(NSString *)json
                        image:(UIImage *)image
                   successful:(SportStringSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"json":json};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    NSLog(@"json:%@",json);
    
    [manager POST:[SPPathConfig createSport] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
        NSLog(@"%lu",(unsigned long)imageData.length);
        NSString *fileName = [NSString stringWithFormat:@"%ld_%@.jpg",(long)[[NSDate date] timeIntervalSince1970],userId];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful",responseObject[@"result"]);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",@"");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",@"");
        } else {
            successful([NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]],responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - Event
#pragma mark 发起人解散运动
- (void)dismissEventWithUserId:(NSString *)userId
                       eventId:(NSString *)eventId
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig dismissEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 活动报名
- (void)enrollEventWithUserId:(NSString *)userId
                      eventId:(NSString *)eventId
                   successful:(SportDicSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig enrollEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful",responseObject[@"result"]);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 参与人退出运动
- (void)exitEventWithUserId:(NSString *)userId
                    eventId:(NSString *)eventId
                 successful:(SportSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig exitEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取运动详情
- (void)getEventWithEventId:(NSString *)eventId
                     userId:(NSString *)userId
                 successful:(SportModelSuccessfulBlock)successful
                    failure:(SportFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"eventId":eventId,@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error;
            SPEventModel *model = [[SPEventModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful(@"JSONModelInitError",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 锁定
- (void)lockWithUserId:(NSString *)userId
               eventId:(NSString *)eventId
            successful:(SportSuccessfulBlock)successful
               failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig lock] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 解锁
- (void)unlockWithUserId:(NSString *)userId
                 eventId:(NSString *)eventId
              successful:(SportSuccessfulBlock)successful
                 failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig unlock] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

- (void)getMessageWithEventId:(NSString *)eventId
                   successful:(SportSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getMessage] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 评价
- (void)postAppraiseWithUserId:(NSString *)userId
                       eventId:(NSString *)eventId
                         grade:(NSString *)grade
                       content:(NSString *)content
                    successful:(SportSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"eventId":eventId,
                                @"grade":grade,
                                @"content":content};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig postAppraise] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 结算
- (void)settlementEventWithUserId:(NSString *)userId
                          eventId:(NSString *)eventId
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"eventId":eventId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig settlementEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 发布留言
- (void)postMessageWithUserId:(NSString *)userId
                      eventId:(NSString *)eventId
                      replyId:(NSString *)replyId
                      content:(NSString *)content
                   successful:(SportSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = nil;
    if (replyId.length == 0 || !replyId) {
        tempParam = @{@"userId":userId,
                      @"eventId":eventId,
                      @"content":content};
    } else {
        tempParam = @{@"userId":userId,
                      @"eventId":eventId,
                      @"replyId":replyId,
                      @"content":content};
    }
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    NSLog(@"param:%@",param);
    
    [manager POST:[SPPathConfig postMessage] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark - Location
- (void)getNearbyEventWithUserId:(NSString *)userId
                        latitude:(NSString *)latitude
                       longitude:(NSString *)longitude
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"latitude":latitude,@"longitude":longitude};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getNearbyEvent] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 根据输入的关键字搜索场地(场馆名 地址名)
- (void)searchPlaceWithUserId:(NSString *)userId
                       search:(NSString *)search
                         city:(NSString *)city
                   successful:(SportModelSuccessfulBlock)successful
                      failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"search":search,@"city":city};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig searchPlace] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPSportsCreateLocationModel *model = [[SPSportsCreateLocationModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

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
                     failure:(SportFailureBlock)failure {
   
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];

    NSDictionary *tempParam = nil;
    
    if (extend) {
        tempParam = @{@"userId":userId,
                      @"name":name,
                      @"sportItem":sportItem,
                      @"extend":extend};
    } else {
        tempParam = @{@"userId":userId,
                      @"name":name,
                      @"sportItem":sportItem};
    }
    
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig createClub] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *iconImageData = UIImageJPEGRepresentation(iconImage, 0.6);
        NSString *iconFileName = [NSString stringWithFormat:@"club_icon_%ld.jpg",(long)[[NSDate date] timeIntervalSince1970]];
        [formData appendPartWithFileData:iconImageData name:@"icon" fileName:iconFileName mimeType:@"image/jpeg"];
        
        NSData *coverImageData = UIImageJPEGRepresentation(coverImage, 0.6);
        NSString *coverFileName = [NSString stringWithFormat:@"club_portrait_%ld.jpg",(long)[[NSDate date] timeIntervalSince1970]];
        [formData appendPartWithFileData:coverImageData name:@"portrait" fileName:coverFileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful",responseObject[@"result"]);
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",responseObject[@"error"]);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",responseObject[@"error"]);
        } else {
            successful(responseObject[@"error"],responseObject[@"result"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}



#pragma mark 发布公告
- (void)pushPublicNoticeWithUserId:(NSString *)userId
                            clubId:(NSString *)clubId
                           content:(NSString *)content
                        successful:(SportSuccessfulBlock)successful
                           failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"clubId":clubId,@"content":content};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig publishAnnouncement] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取俱乐部信息
- (void)getClubDetailWithUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getClubDetail] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPClubDetailResponseModel *model = [[SPClubDetailResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取俱乐部所有成员
- (void)getClubAllMemebersWithClubId:(NSString *)clubId
                          successful:(SportClubMembersSuccessfulBlock)successful
                             failure:(SportFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getClubAllMemebers] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSMutableArray *tempAdminArray = responseObject[@"result"][@"admin"];
            NSMutableArray *adminArray = [[NSMutableArray alloc] init];
            for (NSDictionary *adminDic in tempAdminArray) {
                SPUserInfoModel *userInfoModel = [[SPUserInfoModel alloc] initWithDictionary:adminDic error:nil];
                [adminArray addObject:userInfoModel];
            }
            
            NSMutableDictionary *tempNormalMemberDic = responseObject[@"result"][@"member"];
            NSMutableArray *tempNormalKeyArray = tempNormalMemberDic[@"key"];
            NSMutableArray *tempNormalValueArray = tempNormalMemberDic[@"value"];
            
            NSMutableArray *normalMembersArray = [[NSMutableArray alloc] init];
            for (int i=0; i<tempNormalKeyArray.count; i++) {
                NSMutableArray *tempSectionLetterArray = tempNormalValueArray[i];
                NSMutableArray *sectionLetterArray = [[NSMutableArray alloc] init];
                for (NSDictionary *adminDic in tempSectionLetterArray) {
                    SPUserInfoModel *userInfoModel = [[SPUserInfoModel alloc] initWithDictionary:adminDic error:nil];
                    [sectionLetterArray addObject:userInfoModel];
                }
                
                NSDictionary *tempDic = @{tempNormalKeyArray[i]:sectionLetterArray};
                [normalMembersArray addObject:tempDic];
            }
            
            successful(adminArray,normalMembersArray);
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(nil,nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(nil,nil);
        } else {
            //successful(responseObject[@"error"],nil);
            successful(nil,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 批量增加俱乐部成员
- (void)inviteJoinClubWithClubId:(NSString *)clubId
                          userId:(NSString *)userId
                       targetIds:(NSString *)targetIds
                          extend:(NSString *)extend
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"clubId":clubId,@"userId":userId,@"targetIds":targetIds,@"extend":extend};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig inviteJoinClub] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 批量删除俱乐部成员
- (void)deleteClubMemberBatchWithClubId:(NSString *)clubId
                                 userId:(NSString *)userId
                              memberIds:(NSString *)memberIds
                             successful:(SportSuccessfulBlock)successful
                                failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"clubId":clubId,@"userId":userId,@"memberIds":memberIds};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig deleteClubMemberBatch] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 批量增加俱乐部管理员
- (void)setClubAdminBatchWithClubId:(NSString *)clubId
                             userId:(NSString *)userId
                           adminIds:(NSString *)adminIds
                         successful:(SportSuccessfulBlock)successful
                            failure:(SportFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"clubId":clubId,@"userId":userId,@"adminIds":adminIds};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig setClubAdminBatch] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 批量删除俱乐部管理员
- (void)deleteClubAdminBatchWithClubId:(NSString *)clubId
                                userId:(NSString *)userId
                              adminIds:(NSString *)adminIds
                            successful:(SportSuccessfulBlock)successful
                               failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"clubId":clubId,@"userId":userId,@"adminIds":adminIds};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig deleteClubAdminBatch] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取用户所有俱乐部
- (void)getUserClubsWithUserId:(NSString *)userId
                    successful:(SportModelSuccessfulBlock)successful
                       failure:(SportFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getUserClubs] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPClubListResponseModel *model = [[SPClubListResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 更新加入验证方式
- (void)updateJoinTypeWithUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                        joinType:(NSString *)joinType
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId,
                                @"joinType":joinType};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateClubJoinType] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 更新俱乐部封面
- (void)updateClubCoverWithUserId:(NSString *)userId
                           clubId:(NSString *)clubId
                       coverImage:(UIImage *)coverImage
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateClubCover] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(coverImage, 0.6);
        NSLog(@"%lu",(unsigned long)imageData.length);
        NSString *fileName = [NSString stringWithFormat:@"%ld_%@.jpg",(long)[[NSDate date] timeIntervalSince1970],userId];
        [formData appendPartWithFileData:imageData name:@"portrait" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 更新俱乐部队徽
- (void)updateClubTeamImageWithUserId:(NSString *)userId
                               clubId:(NSString *)clubId
                            teamImage:(UIImage *)teamImage
                           successful:(SportSuccessfulBlock)successful
                              failure:(SportFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateClubTeamImage] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(teamImage, 0.6);
        NSLog(@"%lu",(unsigned long)imageData.length);
        NSString *fileName = [NSString stringWithFormat:@"%ld_%@.jpg",(long)[[NSDate date] timeIntervalSince1970],userId];
        [formData appendPartWithFileData:imageData name:@"icon" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 更新俱乐部名称
- (void)updateClubNameWithUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                            name:(NSString *)name
                      successful:(SportSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId,
                                @"name":name};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateClubName] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 更新俱乐部运动项目
- (void)updateClubEventWithUserId:(NSString *)userId
                           clubId:(NSString *)clubId
                        sportItem:(NSString *)sportItem
                  sportItemExtend:(NSString *)sportItemExtend
                       successful:(SportSuccessfulBlock)successful
                          failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = nil;
    if (!sportItemExtend) {
        tempParam = @{@"userId":userId,
                      @"clubId":clubId,
                      @"sportItem":sportItem};
    } else {
        tempParam = @{@"userId":userId,
                      @"clubId":clubId,
                      @"sportItem":sportItem,
                      @"sportItemExtend":sportItemExtend};
    }
    
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig updateClubEvent] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取俱乐部绑定的运动页
- (void)getClubBindSportsUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                     successful:(SportModelSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getClubBindSports] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPSportsPageResponseModel *model = [[SPSportsPageResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取俱乐部未绑定的运动页
- (void)getClubUnbindSportUserId:(NSString *)userId
                          clubId:(NSString *)clubId
                      successful:(SportModelSuccessfulBlock)successful
                         failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getClubUnbindSports] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPSportsPageResponseModel *model = [[SPSportsPageResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 俱乐部绑定的运动页
- (void)bindSportToClubBatchWithUserId:(NSString *)userId
                                clubId:(NSString *)clubId
                              sportIds:(NSString *)sportIds
                            successful:(SportSuccessfulBlock)successful
                               failure:(SportFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId,
                                @"clubId":clubId,
                                @"sportIds":sportIds};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig bindSportToClubBatch] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 获取邀请加入俱乐部请求列表
- (void)getClubInviteListWithUserId:(NSString *)userId
                         successful:(SportModelSuccessfulBlock)successful
                            failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getInviteRequest] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPClubInviteListResponseModel *model = [[SPClubInviteListResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取申请加入俱乐部请求列表
- (void)getClubApplyListWithUserId:(NSString *)userId
                        successful:(SportModelSuccessfulBlock)successful
                           failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getApplyRequest] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPClubApplyListResponseModel *model = [[SPClubApplyListResponseModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",model);
            } else {
                successful([NSString stringWithFormat:@"JSONModel Error:%@",error.localizedDescription],nil);
            }
            
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError",nil);
        } else {
            successful(responseObject[@"error"],nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 同意加入俱乐部的请求 同意申请加入俱乐部
- (void)agreeJoinClubWithUserId:(NSString *)userId
                      requestId:(NSString *)requestId
                     successful:(SportSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
   
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId,@"requestId":requestId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig agreeJoinClub] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 申请加入俱乐部
- (void)applyJoinClubWithUserId:(NSString *)userId
                         clubId:(NSString *)clubId
                         extend:(NSString *)extend
                     successful:(SportSuccessfulBlock)successful
                        failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId,@"clubId":clubId,@"extend":extend};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig applyJoinClub] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"SignError");
        } else {
            successful(responseObject[@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark - 获取未加入俱乐部的好友
- (void)getNotJoinClubFriendsWithUserId:(NSString *)userId
                                 clubId:(NSString *)clubId
                             successful:(SportClubAddMembersSuccessfulBlock)successful
                                failure:(SportFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPSportBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"clubId":clubId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getNotJoinClubFriends] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSMutableArray *friendsSortedListArray =[[NSMutableArray alloc] init];
            NSMutableArray *friendsListArray =[[NSMutableArray alloc] init];
            
            NSArray *arr1 = responseObject[@"result"][@"data"][@"key"];
            NSArray *arr2 = responseObject[@"result"][@"data"][@"value"];
            
            for (int i=0; i<arr1.count; i++) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr2[i]) {
                    [arr addObject:[[SPUserInfoModel alloc] initWithDictionary:dic error:nil]];
                }
                [friendsSortedListArray addObject:@{arr1[i]:arr}];
                [friendsListArray addObjectsFromArray:arr];
            }
            successful(friendsSortedListArray,friendsListArray);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful([NSMutableArray array],[NSMutableArray array]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}




@end
