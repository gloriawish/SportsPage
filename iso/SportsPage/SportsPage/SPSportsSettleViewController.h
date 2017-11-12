//
//  SPSportsSettleViewController.h
//  SportsPage
//
//  Created by Qin on 2016/12/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import "SPEventModel.h"

@interface SPSportsSettleViewController : SPBaseViewController

@property (nonatomic,copy) NSString *eventId;
@property (nonatomic,copy) NSString *priceStr;

- (void)setUpWithModel:(SPEventModel *)model;

@end
