//
//  SPCreateEventView.h
//  SportsPage
//
//  Created by Qin on 2016/11/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPCreateSportsViewController.h"

@interface SPCreateEventView : UIView

@property (weak, nonatomic) IBOutlet UIView *selectedEventView;

@property (nonatomic,readwrite,weak) SPCreateSportsViewController *createSportsViewController;

@end
