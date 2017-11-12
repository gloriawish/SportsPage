//
//  SPPersonalUpdatePasswordViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/4.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalUpdatePasswordViewController.h"

#import "SPAuthBusinessUnit.h"
#import "SPPINGBusinessUnit.h"

//#import "SPLoginWayViewController.h"
#import "SPLoginViewController.h"
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"
#import "MBProgressHUD.h"

@interface SPPersonalUpdatePasswordViewController () <UITextFieldDelegate> {
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *teleTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordNameLabel;

@end

@implementation SPPersonalUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval confirmCodeTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"updatePasswordConfirmTime"];
    
    if (nowTime - confirmCodeTime < 60) {
        _confirmCodeButton.userInteractionEnabled = false;
        NSString *dataStr = [NSString stringWithFormat:@"(%ds)",59 - (int)(nowTime-confirmCodeTime)];
        [_confirmCodeButton setBackgroundColor:[UIColor grayColor]];
        [_confirmCodeButton setTitle:dataStr forState:UIControlStateNormal];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _confirmCodeButton.userInteractionEnabled = true;
            [_confirmCodeButton setBackgroundColor:[SPGlobalConfig themeColor]];
            [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

#pragma mark - SetUp
- (void)setUp {
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    
    _titleLabel.text = _titleStr;
    _passwordNameLabel.text = _passwordNameStr;
    
    if ([_titleStr isEqualToString:@"修改支付密码"] || [_titleStr isEqualToString:@"设置支付密码"]) {
        _passwordTextField.placeholder = @"请输入6位支付密码";
        _rePasswordTextField.placeholder = @"请确认支付密码";
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _rePasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    _teleTextField.delegate = self;
    _confirmCodeButton.adjustsImageWhenDisabled = self;
    _passwordTextField.delegate = self;
    _rePasswordTextField.delegate = self;
    
    [_confirmCodeButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_confirmCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _confirmCodeButton.layer.cornerRadius = 5;
    _confirmCodeButton.layer.masksToBounds = true;
    
    [_finishedButton setBackgroundColor:[UIColor grayColor]];
    [_finishedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _finishedButton.userInteractionEnabled = false;
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)getConfirmCodeAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (_teleTextField.text.length != 0 && [self isMobileNumber:_teleTextField.text]) {
        [[SPAuthBusinessUnit shareInstance] getVerifyWithMobile:_teleTextField.text successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [SPGlobalConfig showTextOfHUD:@"验证码已发送" ToView:self.view];
                
                NSTimeInterval confirmCodeTime = [[NSDate date] timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults] setDouble:confirmCodeTime forKey:@"updatePasswordConfirmTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [_confirmCodeButton setTitle:@"(59s)" forState:UIControlStateNormal];
                [_confirmCodeButton setBackgroundColor:[UIColor grayColor]];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
            } else {
                [SPGlobalConfig showTextOfHUD:@"验证码获取失败" ToView:self.view];
                _confirmCodeButton.userInteractionEnabled = true;
            }
            
        } failure:^(NSString *errorString) {
            NSLog(@"%@",errorString);
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            _confirmCodeButton.userInteractionEnabled = true;
        }];
    } else {
        [SPGlobalConfig showTextOfHUD:@"请填写正确的手机号" ToView:self.view];
        sender.userInteractionEnabled = true;
    }
}

- (void)confirmCodeCountDown {
    NSString *titleStr = _confirmCodeButton.titleLabel.text;
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"s)" withString:@""];
    int timeNum = [titleStr intValue] - 1;
    if (timeNum <= 0) {
        [_timer invalidate];
        _timer = nil;
        [_confirmCodeButton setBackgroundColor:[SPGlobalConfig themeColor]];
        [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _confirmCodeButton.userInteractionEnabled = true;
    } else {
        titleStr = [NSString stringWithFormat:@"(%ds)",timeNum];
        [_confirmCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

- (IBAction)finishedButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (![self isMobileNumber:_teleTextField.text]) {
        [SPGlobalConfig showTextOfHUD:@"请填写正确的手机号" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }
    if (![_passwordTextField.text isEqualToString:_rePasswordTextField.text]) {
        [SPGlobalConfig showTextOfHUD:@"密码不相同" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }

    if ([_titleStr isEqualToString:@"修改密码"]) {
        NSLog(@"修改密码");
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPAuthBusinessUnit shareInstance] resetPasswordWithMobile:_teleTextField.text password:_passwordTextField.text verify:_confirmCodeTextField.text successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                sender.userInteractionEnabled = true;
                
                [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"isAlreadyLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //SPLoginWayViewController *loginWayVC = [[SPLoginWayViewController alloc] init];
                SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
                navController.navigationBarHidden = true;
                [self.tabBarController presentViewController:navController animated:true completion:^{
                    //__weak UITabBarController *tabBarViewController = self.navigationController.tabBarController;
                    self.tabBarController.selectedIndex = 0;
                    [self.navigationController popToRootViewControllerAnimated:false];
                    //tabBarViewController.selectedIndex = 0;
                    [[RCIM sharedRCIM] logout];
                }];
                
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    sender.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        }];
    } else if ([_titleStr isEqualToString:@"修改支付密码"]  || [_titleStr isEqualToString:@"设置支付密码"]) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPPINGBusinessUnit shareInstance] updatePaypassWithUserId:userId mobile:_teleTextField.text password:_passwordTextField.text verify:_confirmCodeTextField.text successful:^(NSString *successfulString) {
            if ([successfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"修改成功" ToView:self.view];
                    sender.userInteractionEnabled = true;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:true];
                    });
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successfulString ToView:self.view];
                    sender.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_teleTextField.text.length != 0
        && _confirmCodeTextField.text.length != 0
        && _passwordTextField.text.length != 0
        && _rePasswordTextField.text.length != 0) {
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([_titleStr isEqualToString:@"修改支付密码"]) {
        if (textField == _passwordTextField || textField == _rePasswordTextField) {
            if (textField.text.length+string.length > 6) {
                return false;
            } else {
                return true;
            }
        } else {
            return true;
        }
    } else {
        return true;
    }
}

#pragma mark 验证信息
- (BOOL)isMobileNumber:(NSString*)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return[regextestmobile evaluateWithObject:mobileNum];
}

- (BOOL)isPassword:(NSString *)password {
    if (password.length>=6 && password.length<=20) {
        return true;
    } else {
        return false;
    }
}

#pragma mark 取消键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_teleTextField isFirstResponder]) {
        [_teleTextField resignFirstResponder];
    } else if ([_confirmCodeTextField isFirstResponder]) {
        [_confirmCodeTextField resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        [_passwordTextField resignFirstResponder];
    } else if ([_rePasswordTextField isFirstResponder]) {
        [_rePasswordTextField resignFirstResponder];
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
