//
//  SPLoginMobileModel.h
//  SportsPage
//
//  Created by absolute on 2016/10/21.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPLoginMobileModel : JSONModel

@property (nonatomic,readwrite,copy) NSString <Optional> *token;
@property (nonatomic,readwrite,copy) NSString <Optional> *userId;
@property (nonatomic,readwrite,copy) NSString <Optional> *userName;
@property (nonatomic,readwrite,copy) NSString <Optional> *portrait;

@end
