//
//  SPSportsEventShareView.h
//  SportsPage
//
//  Created by Qin on 2016/12/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPSportsEventViewController.h"

@interface SPSportsEventShareView : UIView

@property (nonatomic,weak) SPSportsEventViewController *sportsEventViewController;

- (void)setUpWithTitle:(NSString *)title time:(NSString *)time location:(NSString *)location image:(UIImage *)image eventId:(NSString *)eventId;

@end
