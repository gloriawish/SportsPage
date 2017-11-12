//
//  SPPersonalAccountWaitingViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/23.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountWaitingViewController.h"

@interface SPPersonalAccountWaitingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@end

@implementation SPPersonalAccountWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _accountLabel.text = _accountStr;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_priceStr];
}

#pragma mark - Action
- (IBAction)finishedButtonAction:(id)sender {
    UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-3];
    [self.navigationController popToViewController:vc animated:true];
}

@end
