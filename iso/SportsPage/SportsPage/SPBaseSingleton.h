//
//  BaseSingleton.h
//  SportsPage
//
//  Created by absolute on 2016/10/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface SPBaseSingleton : NSObject

#pragma mark - Singleton
+ (instancetype)shareInstance;

#pragma mark - Sign
+ (NSString *)getSignature:(NSDictionary *)parameters secret:(NSString *)secret;
- (NSDictionary *)getParamWithDictionary:(NSDictionary *)dictionary;

#pragma mark - ContentType
//- (void)addContentType:(NSString *)contentType toManager:(AFHTTPSessionManager *)manager;

@end
