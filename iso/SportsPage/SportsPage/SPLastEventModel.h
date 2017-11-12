//
//  SPLastEventModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPLastEventModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *sport_id;
@property (nonatomic,copy) NSString <Optional> *user_id;
@property (nonatomic,copy) NSString <Optional> *team_type;
@property (nonatomic,copy) NSString <Optional> *charge_type;
@property (nonatomic,copy) NSString <Optional> *privacy;
@property (nonatomic,copy) NSString <Optional> *level;
@property (nonatomic,copy) NSString <Optional> *min_number;
@property (nonatomic,copy) NSString <Optional> *max_number;
@property (nonatomic,copy) NSString <Optional> *price;
@property (nonatomic,copy) NSString <Optional> *start_time;
@property (nonatomic,copy) NSString <Optional> *duration;
@property (nonatomic,copy) NSString <Optional> *operate_time;
@property (nonatomic,copy) NSString <Optional> *status;
@property (nonatomic,copy) NSString <Optional> *time;

@end
