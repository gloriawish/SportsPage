//
//  SPSportsNotificationResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPSportsNotificationModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *cate;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *target_id;
@property (nonatomic,copy) NSString <Optional> *content;
@property (nonatomic,copy) NSString <Optional> *extend;
@property (nonatomic,copy) NSString <Optional> *time;
@property (nonatomic,copy) NSString <Optional> *is_read;

@end

@protocol SPSportsNotificationModel;

@interface SPSportsNotificationResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPSportsNotificationModel> *data;

@end
