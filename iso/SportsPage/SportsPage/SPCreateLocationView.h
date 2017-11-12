//
//  SPCreateLocationView.h
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPCreateLocationViewController.h"
#import "SPSportsCreateLocationResponseModel.h"

@interface SPCreateLocationView : UIView

@property (weak, nonatomic) IBOutlet UIView *selectedLocationView;
@property (nonatomic,readwrite,weak) SPCreateLocationViewController *createLocationViewController;

- (void)setUpWithModel:(SPSportsCreateLocationResponseModel *)model;

@end
