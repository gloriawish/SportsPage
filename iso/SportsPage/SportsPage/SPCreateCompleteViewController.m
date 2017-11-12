//
//  SPCreateCompleteViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateCompleteViewController.h"

#import "SPAuthBusinessUnit.h"
#import "SPUserBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPCreateCompleteViewController () <UITextFieldDelegate> {
    UITextField *_textField;
    UITextField *_confirmCodeTextField;
    UIButton *_confirmCodeButton;
    NSTimer *_timer;
}

@end

@implementation SPCreateCompleteViewController

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
    NSTimeInterval confirmCodeTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"bindConfirmTime"];
    if (nowTime - confirmCodeTime < 60) {
        _confirmCodeButton.userInteractionEnabled = false;
        [_confirmCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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
            [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
            [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        });
    }
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
    scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64);
    scrollview.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    scrollview.showsVerticalScrollIndicator = false;
    [self.view addSubview:scrollview];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [scrollview addGestureRecognizer:tapGesture];
    
    UIView *textView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 45)];
    textView.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 45)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.placeholder = @"填写手机号";
    _textField.keyboardType = UIKeyboardTypePhonePad;
    [textView addSubview:_textField];
    [scrollview addSubview:textView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 44.5, SCREEN_WIDTH-20, 0.5)];
    lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    [textView addSubview:lineView];
    
    UIView *confirmCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 45)];
    confirmCodeView.backgroundColor = [UIColor whiteColor];
    _confirmCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15-100, 45)];
    _confirmCodeTextField.delegate = self;
    _confirmCodeTextField.borderStyle = UITextBorderStyleNone;
    _confirmCodeTextField.font = [UIFont systemFontOfSize:14];
    _confirmCodeTextField.placeholder = @"填写验证码";
    _confirmCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [confirmCodeView addSubview:_confirmCodeTextField];
    
    _confirmCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmCodeButton.frame = CGRectMake(SCREEN_WIDTH-15-100, 0, 100, 45);
    _confirmCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _confirmCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
    [_confirmCodeButton addTarget:self action:@selector(getConfirmCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmCodeView addSubview:_confirmCodeButton];
    [scrollview addSubview:confirmCodeView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 135, SCREEN_WIDTH-20, 20)];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.text = @"您还没有完善信息,完善信息后方可创建运动";
    [scrollview addSubview:infoLabel];
}

#pragma mark - Action
- (IBAction)navBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)finishedButtonAction:(UIButton *)sender {
    if (_confirmCodeTextField.text.length != 0) {
        sender.userInteractionEnabled = false;
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPUserBusinessUnit shareInstance] bindMobileWithUserId:userId mobile:_textField.text verify:_confirmCodeTextField.text successful:^(NSString *successsfulString) {
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"完善成功" ToView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        sender.userInteractionEnabled = true;
                        [self.navigationController popViewControllerAnimated:true];
                    });
                });
            } else {
                NSLog(@"绑定失败,%@",successsfulString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                    sender.userInteractionEnabled = true;
                });
            }
        } failure:^(NSString *errorString) {
            NSLog(@"bindMobile AFN ERROR:%@",errorString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                sender.userInteractionEnabled = true;
            });
        }];
    }
}

- (void)getConfirmCodeAction:(UIButton *)sender {
    if ([self isMobileNumber:_textField.text]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        [[SPAuthBusinessUnit shareInstance] getVerifyWithMobile:_textField.text successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"验证码已发送" ToView:self.view];
                });
                NSTimeInterval confirmCodeTime = [[NSDate date] timeIntervalSince1970];
                [[NSUserDefaults standardUserDefaults] setDouble:confirmCodeTime forKey:@"bindConfirmTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                sender.userInteractionEnabled = false;
                [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [sender setTitle:@"(59s)" forState:UIControlStateNormal];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(confirmCodeCountDown) userInfo:nil repeats:true];
            } else {
                NSLog(@"%@",successsfulString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"获取验证码失败" ToView:self.view];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
        
    } else {
        [SPGlobalConfig showTextOfHUD:@"填写正确的手机号" ToView:self.view];
    }
}

- (void)confirmCodeCountDown {
    NSString *titleStr = _confirmCodeButton.titleLabel.text;
    int  timeNum= [[titleStr substringWithRange:NSMakeRange(1, 2)] intValue] - 1;
    if (timeNum == 0) {
        [_timer invalidate];
        _timer = nil;
        _confirmCodeButton.userInteractionEnabled = true;
        [_confirmCodeButton setTitleColor:[SPGlobalConfig themeColor] forState:UIControlStateNormal];
        [_confirmCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        titleStr = [NSString stringWithFormat:@"(%ds)",timeNum];
        [_confirmCodeButton setTitle:titleStr forState:UIControlStateNormal];
    }
}

- (BOOL)isMobileNumber:(NSString*)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return[regextestmobile evaluateWithObject:mobileNum];
}

- (void)tapAction {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    } else if ([_confirmCodeTextField isFirstResponder]) {
        [_confirmCodeTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
