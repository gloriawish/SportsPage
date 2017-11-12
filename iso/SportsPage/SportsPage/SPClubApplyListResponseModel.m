//
//  SPClubApplyListResponseModel.m
//  SportsPage
//
//  Created by Qin on 2017/4/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubApplyListResponseModel.h"

@implementation SPClubApplyListModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"requestId":@"id"}];
}

@end

@implementation SPClubApplyListResponseModel

@end
