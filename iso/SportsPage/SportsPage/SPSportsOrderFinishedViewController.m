//
//  SPSportsOrderFinishedViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/28.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsOrderFinishedViewController.h"

@interface SPSportsOrderFinishedViewController ()

@property (weak, nonatomic) IBOutlet UIButton *turnToMainButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;

@end

@implementation SPSportsOrderFinishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _imageBottomConstraint.constant = 197;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    
    [_turnToMainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

#pragma mark - Action
- (IBAction)turnToMainAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
