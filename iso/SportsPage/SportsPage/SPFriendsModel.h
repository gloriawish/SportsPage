//
//  SPFriendsModel.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"
#import "SPUserInfoModel.h"

@protocol SPUserInfoModel;

@interface SPFriendsModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *size;
@property (nonatomic,readwrite,strong) NSMutableArray <SPUserInfoModel> *data;

@end
