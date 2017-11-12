//
//  SPClubListResponseModel.m
//  SportsPage
//
//  Created by Qin on 2017/3/14.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubListResponseModel.h"

@implementation SPClubListModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"clubDescription":@"description",
                                                                  @"clubId":@"id"}];
}

@end

@implementation SPClubListResponseModel

@end
