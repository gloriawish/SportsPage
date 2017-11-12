//
//  SPSportsFollowsResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPSportsFollowsModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *sport_id;

@property (nonatomic,copy) NSString <Optional> *portrait;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *creator;
@property (nonatomic,copy) NSString <Optional> *location;

@property (nonatomic,copy) NSString <Optional> *sport_item;
@property (nonatomic,copy) NSString <Optional> *extend;

//@property (nonatomic,copy) NSString <Optional> *place;
//@property (nonatomic,copy) NSString <Optional> *latitude;
//@property (nonatomic,copy) NSString <Optional> *longitude;

//@property (nonatomic,copy) NSString <Optional> *summary;
//@property (nonatomic,copy) NSString <Optional> *sport_type;

//@property (nonatomic,copy) NSString <Optional> *grade;
//@property (nonatomic,copy) NSString <Optional> *status;
//@property (nonatomic,copy) NSString <Optional> *time;

@end

@protocol SPSportsFollowsModel;

@interface SPSportsFollowsResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPSportsFollowsModel> *data;

@end
