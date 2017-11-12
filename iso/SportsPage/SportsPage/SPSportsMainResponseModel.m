//
//  SPSportsMainResponseModel.m
//  SportsPage
//
//  Created by Qin on 2016/11/24.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsMainResponseModel.h"

@implementation SPSportsMainResponseModel

/*
 @property (nonatomic,copy) NSString <Optional> *event_id;
 @property (nonatomic,strong) SPUserInfoModel <Optional> *user_id;
 
 @property (nonatomic,copy) NSString <Optional> *title;
 @property (nonatomic,copy) NSString <Optional> *portrait;
 @property (nonatomic,copy) NSString <Optional> *location;
 @property (nonatomic,copy) NSString <Optional> *location_detail;
 @property (nonatomic,copy) NSString <Optional> *grade;
 
 @property (nonatomic,copy) NSString <Optional> *min_number;
 @property (nonatomic,copy) NSString <Optional> *max_number;
 @property (nonatomic,copy) NSString <Optional> *price;
 @property (nonatomic,copy) NSString <Optional> *start_time;
 @property (nonatomic,copy) NSString <Optional> *duration;
 
 @property (nonatomic,strong) NSMutableArray <NSString *> *enrollUsers;
 */

- (instancetype)init {
    self = [super init];
    if (self) {
        _event_id = @"";
        _user_id = [[SPUserInfoModel alloc] init];
        _title = @"";
        _portrait = @"";
        _location = @"";
        _location_detail = @"";
        _grade = @"";
        _max_number = @"";
        _price = @"";
        _start_time = @"";
        _enrollUsers = [NSMutableArray array];
    }
    return self;
}


+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"enrollUsers":@"_enroll_user",
                                                                  @"sportId":@"id"}];
}

@end
