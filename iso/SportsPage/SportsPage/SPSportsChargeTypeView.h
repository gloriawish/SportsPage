//
//  SPSportsChargeTypeView.h
//  SportsPage
//
//  Created by Qin on 2016/11/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPSPortsOrderViewController.h"

@interface SPSportsChargeTypeView : UIView

@property (weak, nonatomic) IBOutlet UIView *chargeTypeView;

@property (nonatomic,readwrite,weak) SPSPortsOrderViewController *sportsOrderViewController;
@property (nonatomic,copy) NSString *orderNo;
@property (nonatomic,copy) NSString *needPaypass;

- (void)setUpWithBalance:(NSString *)balance price:(NSString *)price;

@end
