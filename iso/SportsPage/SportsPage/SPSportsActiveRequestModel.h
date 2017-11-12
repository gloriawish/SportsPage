//
//  SPSportsActiveRequestModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/16.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPSportsActiveRequestModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *time;
@property (nonatomic,readwrite,copy) NSString <Optional> *date;
@property (nonatomic,readwrite,copy) NSString <Optional> *level;
@property (nonatomic,readwrite,copy) NSString <Optional> *memberBorder;
@property (nonatomic,readwrite,copy) NSString <Optional> *chargeType;
@property (nonatomic,readwrite,copy) NSString <Optional> *price;
@property (nonatomic,readwrite,copy) NSString <Optional> *privacy;

@end