//
//  SPCreateFinishView.h
//  SportsPage
//
//  Created by Qin on 2016/11/13.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCreateNextStepViewController.h"
#import "SPSportsActiveRequestModel.h"

@interface SPCreateFinishView : UIView

@property (weak, nonatomic) IBOutlet UIView *confirmView;

@property (nonatomic,readwrite,weak) SPCreateNextStepViewController *createNextStepViewController;

- (void)setUpDataWithModel:(SPSportsActiveRequestModel *)requestModel;

@end
