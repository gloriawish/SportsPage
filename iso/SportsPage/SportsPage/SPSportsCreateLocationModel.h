//
//  SPSportsCreateLocationModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"
#import "SPSportsCreateLocationResponseModel.h"

@protocol SPSportsCreateLocationResponseModel;

@interface SPSportsCreateLocationModel : JSONModel

@property (nonatomic,retain) NSMutableArray <SPSportsCreateLocationResponseModel> *data;

@end
