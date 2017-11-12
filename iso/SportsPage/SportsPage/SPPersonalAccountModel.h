//
//  SPPersonalAccountModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPPersonalAccountModel : JSONModel

@property (nonatomic,copy) NSString <Optional> * accountId;
@property (nonatomic,copy) NSString <Optional> * user_id;
@property (nonatomic,copy) NSString <Optional> * balance;
@property (nonatomic,copy) NSString <Optional> * freeze;
@property (nonatomic,copy) NSString <Optional> * score;
@property (nonatomic,copy) NSString <Optional> * charge_times;

@end
