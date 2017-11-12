//
//  SPIMBusinessUnit.m
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPIMBusinessUnit.h"
#import "AFNetworking.h"
#import "NSString+Encrypt.h"

@implementation SPIMBusinessUnit

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
static SPIMBusinessUnit *_instance;

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

#pragma mark - IM
#pragma mark 获取融云的Token
- (void)getIMTokenWithUserId:(NSString *)userId
                  successful:(IMStringSuccessfulBlock)successful
                     failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getIMToken] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(responseObject[@"result"]);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取用户信息
- (void)getUserInfoWithUserId:(NSString *)userId
                      success:(IMSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getUserInfo] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPUserInfoModel *model = [[SPUserInfoModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(model);
            } else {
                NSLog(@"jsonToModelError:%@",error.localizedDescription);
                successful(nil);
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@:%@",responseObject[@"code"],responseObject[@"result"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取用户信息(判断是否为好友关系)
- (void)getUserInfoByRelationWithUserId:(NSString *)userId
                               targetId:(NSString *)targetId
                                success:(IMSuccessfulBlock)successful
                                failure:(IMFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"targetId":targetId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getUserInfoByRelation] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPUserInfoModel *model = [[SPUserInfoModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(model);
            } else {
                NSLog(@"jsonToModelError:%@",error.localizedDescription);
                successful(nil);
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@:%@",responseObject[@"code"],responseObject[@"result"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 添加好友
- (void)addFriendWithUserId:(NSString *)userId
                   friendId:(NSString *)friendId
                    message:(NSString *)message
                      extra:(NSString *)extra
                 successful:(IMStringSuccessfulBlock)successful
                    failure:(IMFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = nil;
    if ((!message || message.length == 0) && (extra && extra.length != 0)) {
        tempParam = @{@"userId":userId,
                      @"friendId":friendId,
                      @"extra":extra};
    } else if ((message && message.length != 0) && (!extra || extra.length == 0)) {
        tempParam = @{@"userId":userId,
                      @"friendId":friendId,
                      @"message":message};
    } else if ((!message || message.length == 0) && (!extra || extra.length == 0)) {
        tempParam = @{@"userId":userId,
                      @"friendId":friendId};
    } else {
        tempParam = @{@"userId":userId,
                      @"friendId":friendId,
                      @"message":message,
                      @"extra":extra};
    }
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig addFriend] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 600) {
            successful(@"已经是好友关系");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"]);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 删除好友
- (void)deleteFriendWithUserId:(NSString *)userId
                      friendId:(NSString *)friendId
                    successful:(IMStringSuccessfulBlock)successful
                       failure:(IMFailureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"friendId":friendId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig deleteFriend] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 批量添加好友
- (void)addFriendBatchWithUserId:(NSString *)userId
                       friendIds:(NSString *)friendIds
                         message:(NSString *)message
                           extra:(NSString *)extra
                      successful:(IMStringSuccessfulBlock)successful
                         failure:(IMFailureBlock)failure{
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = nil;
    if ((!message || message.length == 0) && (extra && extra.length != 0)) {
        tempParam = @{@"userId":userId,
                      @"friendIds":friendIds,
                      @"extra":extra};
    } else if ((message && message.length != 0) && (!extra || extra.length == 0)) {
        tempParam = @{@"userId":userId,
                      @"friendIds":friendIds,
                      @"message":message};
    } else if ((!message || message.length == 0) && (!extra || extra.length == 0)) {
        tempParam = @{@"userId":userId,
                      @"friendIds":friendIds};
    } else {
        tempParam = @{@"userId":userId,
                      @"friendIds":friendIds,
                      @"message":message,
                      @"extra":extra};
    }
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig addFriendBatch] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取好友列表
- (void)getFriendsListWithUserId:(NSString *)userId
                      successful:(IMSuccessfulArrayBlock)successful
                         failure:(IMFailureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getFriends] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 创建群组
- (void)createGroupWithUserId:(NSString *)userId
                    groupName:(NSString *)groupName
                        intro:(NSString *)intro
                    memberIds:(NSString *)memberIds
                   successful:(IMStringSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    NSDictionary *tempParam = nil;
    if (groupName.length == 0 && intro.length == 0) {
        tempParam = @{@"userId":userId,
                      @"memberIds":memberIds};
    } else if (groupName.length == 0 && intro.length != 0) {
        tempParam = @{@"userId":userId,
                      @"intro":intro,
                      @"memberIds":memberIds};
    } else if (groupName.length != 0 && intro.length == 0) {
        tempParam = @{@"userId":userId,
                      @"groupName":groupName,
                      @"memberIds":memberIds};
    } else {
        tempParam = @{@"userId":userId,
                      @"groupName":groupName,
                      @"intro":intro,
                      @"memberIds":memberIds};
    }
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig createGroup] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 退出群组
- (void)exitGroupWithUserId:(NSString *)userId
                    groupId:(NSString *)groupId
                 successful:(IMStringSuccessfulBlock)successful
                    failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,@"groupId":groupId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig exitGroup] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取群组信息
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     successful:(IMSuccessfulBlock)successful
                        failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"groupId":groupId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getGroupInfo] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            
            SPGroupModel *model = [[SPGroupModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(model);
            } else {
                NSLog(@"jsonToModelError:%@",error.localizedDescription);
                successful(nil);
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 获取群组成员
- (void)getGroupMembersWithGroupId:(NSString *)groupId
                        successful:(IMModelSuccessfulBlock)successful
                           failure:(IMFailureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"groupId":groupId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getGroupMembers] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPGroupMembersModel *model = [[SPGroupMembersModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (model) {
                successful(@"successful",model);
            } else {
                successful(error.localizedDescription,nil);
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

#pragma mark 获取我的群组列表
- (void)getMyGroupsWithUserId:(NSString *)userId
                   successful:(IMSuccessfulBlock)successful
                      failure:(IMFailureBlock)failure {
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    NSDictionary *tempParam = @{@"userId":userId};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig getMyGroups] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            NSError *error = nil;
            SPMyGroupsModel *model = [[SPMyGroupsModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(model);
            } else {
                NSLog(@"jsonToModelError:%@",error.localizedDescription);
                successful(nil);
            }
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",
                         responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(nil);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 批量加群
- (void)joinGroupBatchWithGroupId:(NSString *)groupId
                          userIds:(NSString *)userIds
                       successful:(IMStringSuccessfulBlock)successful
                          failure:(IMFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"groupId":groupId,
                                @"userIds":userIds};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig joinGroupBatch] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            successful([NSString stringWithFormat:@"%@,%@,%@",
                        responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark 处理好友请求
- (void)processRequestFriendWithUserId:(NSString *)userId
                              friendId:(NSString *)friendId
                              isAccess:(NSString *)isAccess
                            successful:(IMStringSuccessfulBlock)successful
                               failure:(IMFailureBlock)failure {
    
    
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"friendId":friendId,
                                @"isAccess":isAccess};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager POST:[SPPathConfig processRequestFriend] parameters:param progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            successful([NSString stringWithFormat:@"%@,%@,%@",
                        responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
        }
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 搜索好友
- (void)searchFriendWithUserId:(NSString *)userId
                     searchKey:(NSString *)searchKey
                    successful:(IMModelSuccessfulBlock)successful
                       failure:(IMFailureBlock)failure {
    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"searchKey":searchKey};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    [manager GET:[SPPathConfig searchFriend] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] longLongValue] == 200) {
            
            NSError *error = nil;
            SPFriendsModel *friendsModel = [[SPFriendsModel alloc] initWithDictionary:responseObject[@"result"] error:&error];
            if (!error) {
                successful(@"successful",friendsModel);
            } else {
                NSLog(@"JSONModel Error:%@",error.localizedDescription);
                successful(@"JsonModel error",nil);
            }
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest",nil);
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError",nil);
        } else {
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@,%@",
                         responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
            successful(responseObject[@"error"],nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
    
}

#pragma mark 发送自定义运动消息
- (void)sendSportIMMessageWithUserId:(NSString *)userId
                                type:(NSString *)type
                            targetId:(NSString *)targetId
                          objectName:(NSString *)objectName
                                json:(NSString *)json
                          successful:(IMStringSuccessfulBlock)successful
                             failure:(IMFailureBlock)failure {

    AFHTTPSessionManager *manager = [SPIMBusinessUnit shareManager];
    
    NSDictionary *tempParam = @{@"userId":userId,
                                @"type":type,
                                @"targetId":targetId,
                                @"objectName":objectName,
                                @"json":json};
    NSDictionary *param = [self getParamWithDictionary:tempParam];
    
    NSLog(@"param:%@",param);
    
    [manager POST:[SPPathConfig sendSportIMMessage] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
        if ([responseObject[@"code"] longLongValue] == 200) {
            successful(@"successful");
        } else if ([responseObject[@"code"] longLongValue] == 500) {
            successful(@"InvalidRequest");
        } else if ([responseObject[@"code"] longLongValue] == 1000) {
            successful(@"signError");
        } else {
            successful([NSString stringWithFormat:@"%@,%@,%@",
                        responseObject[@"code"],responseObject[@"result"],responseObject[@"error"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error.localizedDescription);
    }];
}

@end
