//
//  SPSportsSignedUpViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPUserInfoModel.h"

@interface SPSportsSignedUpViewController : UIViewController

@property (nonatomic,strong) SPUserInfoModel *initiateInfoModel;
@property (nonatomic,strong) NSMutableArray <SPUserInfoModel *> *dataArray;

@end
