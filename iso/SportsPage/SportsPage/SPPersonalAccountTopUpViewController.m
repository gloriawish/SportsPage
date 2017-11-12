//
//  SPPersonalAccountTopUpViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountTopUpViewController.h"

#import "Pingpp.h"
#import "SPPINGBusinessUnit.h"
#import "MBProgressHUD.h"

//修改AppDelegate的pingppResult
#import "AppDelegate.h"

#import "SPPersonalAccountViewController.h"

@interface SPPersonalAccountTopUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *topUpButton;

@end

@implementation SPPersonalAccountTopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//NOTIFICATION_PINGPP_PAY

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PINGPP_TopOn object:nil];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _amountTextField.delegate = self;
    
    [_topUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_topUpButton setBackgroundColor:[UIColor grayColor]];
    _topUpButton.layer.cornerRadius = 5;
    _topUpButton.layer.masksToBounds = true;
    _topUpButton.userInteractionEnabled = false;
    
    [self setUpNotification];
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationAction:)
                                                 name:NOTIFICATION_PINGPP_TopOn
                                               object:nil];
}

#pragma mark - NotificationAction
- (void)notificationAction:(NSNotification *)notification {
    __weak SPPersonalAccountViewController *accountViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    [accountViewController networkRequest];
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)topUpButtonAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
#warning 这里修改
    //_amountTextField.text
    [[SPPINGBusinessUnit shareInstance] getPayChargeWithUserId:userId amount:@"0.01" channel:@"wx" subject:@"充值" successful:^(NSDictionary *dic) {
        if (dic) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            NSString *charge = dic[@"charge"];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.pingppResult = @"充值";
            delegate.payAmount = @"0.01";
            //delegate.payAmount = _amountTextField.text;
            
            [Pingpp createPayment:charge appURLScheme:KEY_WEIXIN withCompletion:nil];
            
//            [Pingpp createPayment:charge appURLScheme:KEY_WEIXIN withCompletion:^(NSString *result, PingppError *error) {
//                if (!error) {
//                    NSLog(@"createPaymentResult:%@",result);
//                } else {
//                    NSLog(@"PingppError:%lu,%@",(unsigned long)error.code,[error getMsg]);
//                    [MBProgressHUD hideHUDForView:self.view animated:true];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SPGlobalConfig showTextOfHUD:[error getMsg] ToView:self.view];
//                    });
//                }
//            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        NSLog(@"getPayCharge AFN ERROR:%@",errorString);
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_amountTextField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text.length != 0) {
        if (!_topUpButton.userInteractionEnabled) {
            [_topUpButton setBackgroundColor:[SPGlobalConfig themeColor]];
            _topUpButton.userInteractionEnabled = true;
        }
    } else {
        if (_topUpButton.userInteractionEnabled) {
            [_topUpButton setBackgroundColor:[UIColor grayColor]];
            _topUpButton.userInteractionEnabled = false;
        }
    }
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_amountTextField isFirstResponder]) {
        [_amountTextField resignFirstResponder];
    }
}

@end
