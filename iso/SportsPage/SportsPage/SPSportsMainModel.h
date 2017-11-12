//
//  SPSportsMainModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/24.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

#import "SPSportsMainResponseModel.h"

@protocol SPSportsMainResponseModel;
@interface SPSportsMainModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPSportsMainResponseModel> *data;

@end
