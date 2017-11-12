//
//  SPSportsCreateRequestModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPSportsCreateRequestModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *sport_type;
@property (nonatomic,copy) NSString <Optional> *sport_item;
@property (nonatomic,copy) NSString <Optional> *summary;
@property (nonatomic,copy) NSString <Optional> *location;
@property (nonatomic,copy) NSString <Optional> *place;
@property (nonatomic,copy) NSString <Optional> *longitude;
@property (nonatomic,copy) NSString <Optional> *latitude;
@property (nonatomic,copy) NSString <Optional> *extend;

@end
