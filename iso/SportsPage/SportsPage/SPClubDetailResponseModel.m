//
//  SPClubDetailResponseModel.m
//  SportsPage
//
//  Created by Qin on 2017/3/7.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubDetailResponseModel.h"

#import "SPUserInfoModel.h"

@implementation SPClubDetailAnnResponseModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"annId":@"id"}];
}

@end

@implementation SPClubDetailActiveModel

@end

@implementation SPClubDetailResponseModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"clubDescription":@"description",
                                                                  @"clubId":@"id",
                                                                  @"extend":@"sport_item_extend"}];
}

@end
