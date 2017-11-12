//
//  SPEventModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPEventModel.h"

@implementation SPEventModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"enrollUsers":@"_enroll_user",
                                                                  @"messages":@"_message",
                                                                  @"sportId":@"id"}];
}

@end
