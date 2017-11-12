//
//  SPMyGroupsModel.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"
#import "SPGroupModel.h"

@protocol SPGroupModel;

@interface SPMyGroupsModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *size;
@property (nonatomic,readwrite,strong) NSMutableArray <SPGroupModel> *data;

@end
