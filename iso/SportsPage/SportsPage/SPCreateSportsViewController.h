//
//  SPCreateSportsViewController.h
//  SportsPage
//
//  Created by Qin on 2016/11/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@interface SPCreateSportsViewController : SPBaseViewController

@property (assign, nonatomic) BOOL eventShowKeyboard;

@property (weak, nonatomic) IBOutlet UITextField *eventTextField;

@property (nonatomic,readwrite,strong) UIImageView *windowImageView;

@end
