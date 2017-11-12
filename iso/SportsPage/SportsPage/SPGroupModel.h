//
//  SPGroupModel.h
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPGroupModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *groupId;
@property (nonatomic,readwrite,copy) NSString <Optional> *name;
@property (nonatomic,readwrite,copy) NSString <Optional> *portrait;
@property (nonatomic,readwrite,copy) NSString <Optional> *introduce;
@property (nonatomic,readwrite,copy) NSString <Optional> *size;
@property (nonatomic,readwrite,copy) NSString <Optional> *extend;
@property (nonatomic,readwrite,copy) NSString <Optional> *owner;
@property (nonatomic,readwrite,copy) NSString <Optional> *create_time;

@end
