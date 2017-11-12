//
//  SPSportsCreateLocationResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPSportsCreateLocationResponseModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *city;
@property (nonatomic,copy) NSString <Optional> *name;
@property (nonatomic,copy) NSString <Optional> *address;
@property (nonatomic,copy) NSString <Optional> *latitude;
@property (nonatomic,copy) NSString <Optional> *longitude;
@property (nonatomic,copy) NSString <Optional> *image_url;
@property (nonatomic,copy) NSString <Optional> *category;
@property (nonatomic,copy) NSString <Optional> *phone;
@property (nonatomic,copy) NSString <Optional> *geohash;

@end
