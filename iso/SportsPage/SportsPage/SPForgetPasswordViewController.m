//
//  SPForgetPasswordViewController.m
//  LoginMode
//
//  Created by Qin on 2016/10/23.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPForgetPasswordViewController.h"

#import "SPAuthBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPForgetPasswordViewController () <UITextFieldDelegate> {
    BOOL _verifyTele;
    BOOL _verifyPassword;
    BOOL _verifyConfirmCode;
    
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;

@property (weak, nonatomic) IBOutlet UITextField *teleTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *dismissLabel;

@end

@implementation SPForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    
    _dismissLabel.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLabelAction:)];
    [_dismissLabel addGestureRecognizer:tapGesture];
    
    _teleTextField.delegate = self;
    _passwordTextField.delegate = self;
    _confirmCodeTextField.delegate = self;
    
    UIColor *placeholderColor = [SPGlobalConfig anyColorWithRed:255 green:255 blue:255 alpha:0.5];
    [_teleTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    [_confirmCodeTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    [_passwordTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    
    _verifyTele = false;
    _verifyPassword = false;
    _verifyConfirmCode = false;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval confirmCodeTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"resetConfirmTime"];
    
    if (nowTime - confirmCodeTime < 60) {
        _confirmCodeButton.userInteractionEnabled = false;
        //[_confirmCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString *dataStr = [NSString stringWithFormat:@"(%ds)",59 - (int)(nowTime-confirmCodeTime)];
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
            //[_confirmCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissLabelAction:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)resetPasswordAction:(UIButton *)sender {
    if ([_teleTextField isFirstResponder]) {
        [_teleTextField resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        [_passwordTextField resignFirstResponder];
    } else if ([_confirmCodeTextField isFirstResponder]) {
        [_confirmCodeTextField resignFirstResponder];
    }
    
    if ([self isMobileNumber:_teleTextField.text]) {
        _verifyTele = true;
    }
    
    if (_passwordTextField.text.length >= 6 && _passwordTextField.text.length <= 20) {
        _verifyPassword = true;
    }
    
    if (_confirmCodeTextField.text.length == 4) {
        _verifyConfirmCode = true;
    }
    
    if (_verifyTele && _verifyPassword && _verifyConfirmCode) {
        NSLog(@"重置密码");
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        [[SPAuthBusinessUnit shareInstance] resetPasswordWithMobile:_teleTextField.text password:_passwordTextField.text verify:_confirmCodeTextField.text successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                NSLog(@"重置密码成功");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
                    [SPGlobalConfig showTextOfHUD:@"重置密码成功" ToView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //重置密码成功后,跳转回登录
                        [self dismissViewControllerAnimated:true completion:nil];
                    });
                    
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                NSLog(@"%@",successsfulString);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"重置密码失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            NSLog(@"%@",errorString);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
        
    } else {
        if (!_verifyTele) {
            [SPGlobalConfig showTextOfHUD:@"手机号有误" ToView:self.view];
        } else if (!_verifyConfirmCode) {
            [SPGlobalConfig showTextOfHUD:@"验证码有误" ToView:self.view];
        } else if (!_verifyPassword) {
            [SPGlobalConfig showTextOfHUD:@"密码有误" ToView:self.view];
        }
    }
}

- (IBAction)getConfirmCodeAction:(UIButton *)sender {
    if (_teleTextField.text.length == 0 || _teleTextField.text == nil) {
        [SPGlobalConfig showTextOfHUD:@"请填写手机号" ToView:self.view];
    } else {
        [[SPAuthBusinessUnit shareInstance] getVerifyWithMobile:_teleTextField.text successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [SPGlobalConfig showTextOfHUD:@"验证码已发送" ToView:self.view];
                
                NSTimeInterval confirmCodeTime = [[NSDate date] timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults] setDouble:confirmCodeTime forKey:@"resetConfirmTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                sender.userInteractionEnabled = false;
                [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [sender setTitle:@"(59s)" forState:UIControlStateNormal];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
            } else {
                NSLog(@"%@",successsfulString);
                [SPGlobalConfig showTextOfHUD:@"获取验证码失败" ToView:self.view];
            }
            
            
        } failure:^(NSString *errorString) {
            [SPGlobalConfig showTextOfHUD:@"获取验证码失败" ToView:self.view];
        }];
    }
}

- (void)confirmCodeCountDown {
    NSString *titleStr = _confirmCodeButton.titleLabel.text;
    int  timeNum= [[titleStr substringWithRange:NSMakeRange(1, 2)] intValue] - 1;
    if (timeNum == 0) {
        [_timer invalidate];
        _timer = nil;
        _confirmCodeButton.userInteractionEnabled = true;
        [_confirmCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        titleStr = [NSString stringWithFormat:@"(%ds)",timeNum];
        [_confirmCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _teleTextField) {
        if (range.location <= 10) {
            if (range.location == 10 && range.length == 0) {
                NSString *teleString = [NSString stringWithFormat:@"%@%@",textField.text,string];
                if ([self isMobileNumber:teleString]) {
                    _verifyTele = true;
                } else {
                    _verifyTele = false;
                }
            }
            return true;
        } else {
            return false;
        }
    } else if (textField == _confirmCodeTextField) {
        if (range.location <= 3) {
            if (range.location == 3 && range.length == 0) {
                _verifyConfirmCode = true;
            } else {
                _verifyConfirmCode = false;
            }
            return true;
        } else {
            return false;
        }
    } else if (textField == _passwordTextField) {
        if (range.location <= 19) {
            NSString *passwordString = [NSString stringWithFormat:@"%@%@",textField.text,string];
            if ([self isPassword:passwordString]) {
                _verifyPassword = true;
            } else {
                _verifyPassword = false;
            }
            return true;
        } else {
            return false;
        }
    }
    return false;
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
    [_confirmCodeTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

@end
