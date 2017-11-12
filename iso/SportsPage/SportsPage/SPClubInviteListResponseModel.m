//
//  SPClubInviteListResponseModel.m
//  SportsPage
//
//  Created by Qin on 2017/4/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubInviteListResponseModel.h"

@implementation SPClubInviteListModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"requestId":@"id"}];
}

@end

@implementation SPClubInviteListResponseModel

@end
