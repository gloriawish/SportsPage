//
//  SPSportsMainResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/24.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

#import "SPUserInfoModel.h"

@protocol SPUserInfoModel;

@interface SPSportsMainResponseModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *sportId;
@property (nonatomic,copy) NSString <Optional> *event_id;
@property (nonatomic,strong) SPUserInfoModel <Optional> *user_id;

@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *portrait;
@property (nonatomic,copy) NSString <Optional> *location;
@property (nonatomic,copy) NSString <Optional> *location_detail;
@property (nonatomic,copy) NSString <Optional> *grade;

@property (nonatomic,copy) NSString <Optional> *max_number;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *start_time;

@property (nonatomic,copy) NSString <Optional> *status; //1.激活 0.未激活
@property (nonatomic,copy) NSString <Optional> *event_status;

@property (nonatomic,strong) NSMutableArray <SPUserInfoModel> *enrollUsers;


@end
