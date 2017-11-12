//
//  SPPersonalAccountDefiniteResponseModel.h
//  SportsPage
//
//  Created by Qin on 2016/12/5.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

@interface SPPersonalAccountDefiniteModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *user_id;
@property (nonatomic,copy) NSString <Optional> *type;
@property (nonatomic,copy) NSString <Optional> *amount;
@property (nonatomic,copy) NSString <Optional> *remark;
@property (nonatomic,copy) NSString <Optional> *balance;
@property (nonatomic,copy) NSString <Optional> *time;

@end

@protocol SPPersonalAccountDefiniteModel;

@interface SPPersonalAccountDefiniteResponseModel : JSONModel

@property (nonatomic,strong) NSMutableArray <SPPersonalAccountDefiniteModel> *data;

@end
