//
//  SPPersonalInfoModel.h
//  SportsPage
//
//  Created by Qin on 2016/11/18.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "JSONModel.h"

#import "SPUserInfoModel.h"
#import "SPPersonalAccountModel.h"

@interface SPPersonalInfoModel : JSONModel

@property (nonatomic,strong) SPUserInfoModel <Optional> *user;
@property (nonatomic,strong) SPPersonalAccountModel <Optional> *account;

@end
