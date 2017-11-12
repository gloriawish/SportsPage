//
//  SPSportsPageModel.m
//  SportsPage
//
//  Created by Qin on 2016/12/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageBaseModel.h"

@implementation SPSportsPageBaseModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"sportId":@"id"}];
}

@end
