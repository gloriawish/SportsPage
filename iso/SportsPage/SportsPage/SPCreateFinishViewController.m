//
//  SPCreateFinishViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/24.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateFinishViewController.h"

#import "SPSportsEventViewController.h"

@interface SPCreateFinishViewController ()

@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (weak, nonatomic) IBOutlet UIButton *turnToMainButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;

@end

@implementation SPCreateFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    _imageBottomConstraint.constant = 50;
    [UIView animateWithDuration:1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - SetUp
- (void)setUp {
    
    _finishedButton.backgroundColor = [SPGlobalConfig themeColor];
    _finishedButton.layer.masksToBounds = true;
    _finishedButton.layer.cornerRadius = 5;
    
    [_turnToMainButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

#pragma mark - Action
- (IBAction)turnToMainAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)finishedButtonAction:(id)sender {
    
    SPSportsEventViewController *sportsEventViewController = [[SPSportsEventViewController alloc] init];
    sportsEventViewController.eventId = _eventId;
    [self.navigationController pushViewController:sportsEventViewController animated:true];
    
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
