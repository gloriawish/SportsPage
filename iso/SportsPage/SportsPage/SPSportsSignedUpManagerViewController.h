//
//  SPSportsSignedUpManagerViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import "SPUserInfoModel.h"

@interface SPSportsSignedUpManagerViewController : SPBaseViewController

@property (nonatomic,strong) SPUserInfoModel *initiateInfoModel;
@property (nonatomic,strong) NSMutableArray <SPUserInfoModel *> *dataArray;

@end
