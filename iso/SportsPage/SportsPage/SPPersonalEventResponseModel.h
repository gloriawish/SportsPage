//
//  SPPersonalEventResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"


@interface SPPersonalEventModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *event_id;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *location;
@property (nonatomic,copy) NSString <Optional> *start_time;
@property (nonatomic,copy) NSString <Optional> *end_time;
@property (nonatomic,copy) NSString <Optional> *portrait;
@property (nonatomic,copy) NSString <Optional> *creator;
@property (nonatomic,copy) NSString <Optional> *sport_item;
@property (nonatomic,copy) NSString <Optional> *charge_type;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *max_number;
@property (nonatomic,copy) NSString <Optional> *enroll_number;
@property (nonatomic,copy) NSString <Optional> *status;
@property (nonatomic,copy) NSString <Optional> *type;

@end

@protocol SPPersonalEventModel;

@interface SPPersonalEventResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPPersonalEventModel> *data;

@end
