//
//  SPSPortsOrderViewController.h
//  SportsPage
//
//  Created by Qin on 2016/11/25.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

#import "SPEventModel.h"

@interface SPSPortsOrderViewController : SPBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (nonatomic,readwrite,strong) UIImageView *windowImageView;

- (void)setUpWithModel:(SPEventModel *)model;

@end
