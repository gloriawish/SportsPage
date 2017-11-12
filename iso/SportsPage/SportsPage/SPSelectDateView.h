//
//  SPSelectDateView.h
//  SportsPage
//
//  Created by Qin on 2016/11/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCreateNextStepViewController.h"

@interface SPSelectDateView : UIView

@property (weak, nonatomic) IBOutlet UIView *dateSelectView;

@property (nonatomic,readwrite,weak) SPCreateNextStepViewController *createNextStepViewController;
@property (nonatomic,readwrite,strong) NSIndexPath *indexPath;

@end
