
//
//  SPPersonalAccountWithDrawViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountWithDrawViewController.h"

#import "SPPINGBusinessUnit.h"
#import "MBProgressHUD.h"

#import "SPPersonalAccountWaitingViewController.h"

@interface SPPersonalAccountWithDrawViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *walletTextField;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@end

@implementation SPPersonalAccountWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_finishedButton setBackgroundColor:[UIColor grayColor]];
    _finishedButton.userInteractionEnabled = false;
    
    _contentLabel.text = [NSString stringWithFormat:@"可提现金额%@元",_contentStr];
    
    _allLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAllAction:)];
    [_allLabel addGestureRecognizer:tapGesture];
    
    _accountTextField.delegate = self;
    _nameTextField.delegate = self;
    _walletTextField.delegate = self;
}

#pragma mark - Action
- (IBAction)finishedButtonAction:(id)sender {
    NSLog(@"%s",__func__);
    if ([_walletTextField.text doubleValue] > [_contentStr doubleValue]) {
        [SPGlobalConfig showTextOfHUD:@"提现金额大于余额" ToView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPPINGBusinessUnit shareInstance] submitWithdrawWithUserId:userId account:_accountTextField.text name:_nameTextField.text amount:_walletTextField.text successful:^(NSString *successfulString) {
        if ([successfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            SPPersonalAccountWaitingViewController *waitingViewController = [[SPPersonalAccountWaitingViewController alloc] init];
            waitingViewController.priceStr = _walletTextField.text;
            waitingViewController.accountStr = _accountTextField.text;
            [self.navigationController pushViewController:waitingViewController animated:true];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SPGlobalConfig showTextOfHUD:@"提交成功，请耐心等待金额到账" ToView:self.view];
//            });
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:successfulString ToView:self.view];
            });
        }
    } failure:^(NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
}

- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)tapAllAction:(UITapGestureRecognizer *)sender {
    if ([_contentStr containsString:@"."]) {
        _walletTextField.text = [[_contentStr componentsSeparatedByString:@"."] objectAtIndex:0];
    } else {
        _walletTextField.text = _contentStr;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_walletTextField.text.length != 0
        && _accountTextField.text.length != 0
        && _nameTextField.text.length != 0) {
        [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
        _finishedButton.userInteractionEnabled = true;
    } else {
        [_finishedButton setBackgroundColor:[UIColor grayColor]];
        _finishedButton.userInteractionEnabled = false;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_accountTextField isFirstResponder]) {
        [_accountTextField resignFirstResponder];
    } else if ([_walletTextField isFirstResponder]) {
        [_walletTextField resignFirstResponder];
    } else if ([_nameTextField isFirstResponder]) {
        [_nameTextField resignFirstResponder];
    }
}

@end
