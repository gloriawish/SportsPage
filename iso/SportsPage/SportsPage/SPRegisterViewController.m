//
//  PasswordViewController.m
//  LoginMode
//
//  Created by absolute on 2016/10/14.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPRegisterViewController.h"
//#import "SPLoginViewController.h"

#import "SPAuthBusinessUnit.h"
#import "SPIMBusinessUnit.h"
#import "SPUserBusinessUnit.h"

#import "AppDelegate.h"
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"
#import "SPIMDataSource.h"

#import "MBProgressHUD.h"

#import "SPProtocolViewController.h"

@interface SPRegisterViewController () <UITextFieldDelegate> {
    
    BOOL _verifyTele;
    BOOL _verifyConfirm;
    BOOL _verifyPassword;
    
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@property (weak, nonatomic) IBOutlet UITextField *teleTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *confirmCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@end

@implementation SPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToLoginPage:)];
    [_loginLabel addGestureRecognizer:tap];
    _loginLabel.userInteractionEnabled = true;
    
    _teleTextField.delegate = self;
    _confirmCodeTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    UIColor *placeholderColor = [SPGlobalConfig anyColorWithRed:255 green:255 blue:255 alpha:0.5];
    [_teleTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    [_confirmCodeTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    [_passwordTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    
    _verifyTele = false;
    _verifyConfirm = false;
    _verifyPassword = false;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"登录注册表明您同意【运动页服务协议】"];
    NSRange contentRange = {10,7};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _protocolLabel.attributedText = content;
    _protocolLabel.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tapPro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tapPro];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval confirmCodeTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"registerConfirmTime"];
    
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
            //[_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
            [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)protocolAction:(id)sender {
    SPProtocolViewController *protocolVC = [[SPProtocolViewController alloc] init];
    [self presentViewController:protocolVC animated:true completion:nil];
}

- (IBAction)registerAction:(id)sender {
    if ([_teleTextField isFirstResponder]) {
        [_teleTextField resignFirstResponder];
    } else if ([_confirmCodeTextField isFirstResponder]) {
        [_confirmCodeTextField resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        [_passwordTextField resignFirstResponder];
    }
    
    if ([self isMobileNumber:_teleTextField.text]) {
        _verifyTele = true;
    }
    
    if (_passwordTextField.text.length >= 6 && _passwordTextField.text.length <= 20) {
        _verifyPassword = true;
    }
    
    if (_confirmCodeTextField.text.length == 4) {
        _verifyConfirm = true;
    }
    
    if (_verifyTele && _verifyConfirm && _verifyPassword) {
        NSLog(@"确认注册");
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        [[SPAuthBusinessUnit shareInstance] registerWithMobile:_teleTextField.text nick:nil password:_passwordTextField.text verify:_confirmCodeTextField.text successful:^(NSString *successsfulString) {
            NSLog(@"注册成功");

            if ([successsfulString isEqualToString:@"200"]) {
                //直接登录
                [[SPAuthBusinessUnit shareInstance] loginWithMobileByMobile:_teleTextField.text password:_passwordTextField.text successful:^(SPUserInfoModel *model) {
                    
                    if (model) {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        //通过token登录融云服务器
                        [self loginRongCloudServerWithToken:model.token];
                    } else {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"登陆失败" ToView:self.view];
                        });
                    }
                    
                } failure:^(NSString *errorString) {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                    });
                }];
                
            } else if ([successsfulString isEqualToString:@"600"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"该手机号已注册" ToView:self.view];
                });
            }
            
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"注册失败" ToView:self.view];
            });
        }];
    } else {
        if (!_verifyTele) {
            [SPGlobalConfig showTextOfHUD:@"手机号有误" ToView:self.view];
        } else if (!_verifyConfirm) {
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
                [SPGlobalConfig showTextOfHUD:@"验证码已发送到手机" ToView:self.view];
                
                NSTimeInterval confirmCodeTime = [[NSDate date] timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults] setDouble:confirmCodeTime forKey:@"registerConfirmTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                sender.userInteractionEnabled = false;
                //[sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [sender setTitle:@"(59s)" forState:UIControlStateNormal];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
            } else {
                NSLog(@"%@",successsfulString);
                [SPGlobalConfig showTextOfHUD:@"验证码获取失败" ToView:self.view];
            }
            
        } failure:^(NSString *errorString) {
            [SPGlobalConfig showTextOfHUD:@"验证码获取失败" ToView:self.view];
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

- (void)turnToLoginPage:(UITapGestureRecognizer *)sender {
//    SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
//    [self.navigationController pushViewController:loginViewController animated:true];
    [self.navigationController popViewControllerAnimated:true];
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
                _verifyConfirm = true;
            } else {
                _verifyConfirm = false;
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
- (BOOL)isMobileNumber:(NSString *)mobileNum {
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
    }
}

#pragma mark - InitRongCloud
- (void)loginRongCloudServerWithToken:(NSString *)token {
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功,当前登录用户ID:%@",userId);
        
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isAlreadyLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //向后台发送CID
        NSString *CID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CID"];
        if (CID) {
            [[SPUserBusinessUnit shareInstance] regPushServiceWithUserId:userId cid:CID platform:@"iOS" successful:^(NSString *successsfulString) {
                if ([successsfulString isEqualToString:@"successful"]) {
                    NSLog(@"regPushService successful:%@",successsfulString);
                } else {
                    NSLog(@"regPushService failure:%@",successsfulString);
                }
            } failure:^(NSString *errorString) {
                NSLog(@"regPushService AFN ERROR:%@",errorString);
            }];
        } else {
            NSLog(@"CID为空");
        }
        
        //通过userId搜索user用户的好友,全局缓存
        [[SPIMBusinessUnit shareInstance] getFriendsListWithUserId:userId successful:^(NSMutableArray *friendsSortedList, NSMutableArray *friendsList) {
            if (friendsList.count != 0 && friendsSortedList.count != 0) {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.friendsSortedListArray = friendsSortedList;
                delegate.friendsListArray = friendsList;
                NSLog(@"获取好友缓存成功");
            }
        } failure:^(NSString *errorString) {
            NSLog(@"网络请求好友数据失败:%@",errorString);
        }];
        
        //todo 群组缓存
        
        //模态跳转回rootViewController,登录完成
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登录失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
        });
    } tokenIncorrect:^{
        NSLog(@"token错误");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
        });
    }];
}

@end
