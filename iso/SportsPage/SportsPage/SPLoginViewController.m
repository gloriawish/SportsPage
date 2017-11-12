//
//  SPLoginViewController.m
//  LoginMode
//
//  Created by Qin on 2016/10/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPLoginViewController.h"
//#import "SPLoginWayViewController.h"
#import "SPRegisterViewController.h"
#import "SPForgetPasswordViewController.h"

#import "SPAuthBusinessUnit.h"
#import "SPIMBusinessUnit.h"
#import "SPUserBusinessUnit.h"

#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

#import "AppDelegate.h"
#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"
#import "SPIMDataSource.h"
#import "MBProgressHUD.h"

#import "SPTabBarViewController.h"

#import "SPProtocolViewController.h"

#import <TencentOpenAPI/TencentOAuth.h>

@interface SPLoginViewController () <UITextFieldDelegate,WXApiManagerDelegate,TencentSessionDelegate> {
    BOOL _verifyTele;
    BOOL _verifyPassword;
    
    TencentOAuth *_tencentOAuth;
}

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *registerlabel;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;

@property (weak, nonatomic) IBOutlet UITextField *teleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;

@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqConstraint;

@property (weak, nonatomic) IBOutlet UIView *orView;

@end

@implementation SPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    if (![WXApi isWXAppInstalled]) {
        _weChatButton.hidden = true;
    }
    
    if (![TencentOAuth iphoneQQInstalled]) {
        _qqLoginButton.hidden = true;
    }
    
    if (![WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled]) {
        _orView.hidden = true;
    } else if (![WXApi isWXAppInstalled] && [TencentOAuth iphoneQQInstalled]) {
        _qqConstraint.constant = SCREEN_WIDTH/2 - 25;
    } else if ([WXApi isWXAppInstalled] && ![TencentOAuth iphoneQQInstalled]) {
        _weChatConstraint.constant = SCREEN_WIDTH/2 - 25;
    }
    
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerAction:)];
    [_registerlabel addGestureRecognizer:tapRegister];
    _registerlabel.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tapPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordAction:)];
    [_forgetPasswordLabel addGestureRecognizer:tapPassword];
    _forgetPasswordLabel.userInteractionEnabled = true;
    
    _teleTextfield.delegate = self;
    _passwordTextField.delegate = self;
    
    UIColor *placeholderColor = [SPGlobalConfig anyColorWithRed:255 green:255 blue:255 alpha:0.5];
    [_teleTextfield setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    [_passwordTextField setValue:placeholderColor forKeyPath:@"placeholderLabel.textColor"];
    
    _verifyTele = false;
    _verifyPassword = false;
    
    [WXApiManager sharedManager].delegate = self;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"登录注册表明您同意【运动页服务协议】"];
    NSRange contentRange = {10,7};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    _protocolLabel.attributedText = content;
    _protocolLabel.userInteractionEnabled = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolAction:)];
    [_protocolLabel addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)protocolAction:(id)sender {
    SPProtocolViewController *protocolVC = [[SPProtocolViewController alloc] init];
    [self presentViewController:protocolVC animated:true completion:nil];
}

//登录button事件
- (IBAction)loginAction:(id)sender {
    if ([_teleTextfield isFirstResponder]) {
        [_teleTextfield resignFirstResponder];
    } else if ([_passwordTextField isFirstResponder]) {
        [_passwordTextField resignFirstResponder];
    }
    
    if ([self isMobileNumber:_teleTextfield.text]) {
        _verifyTele = true;
    }
    
    if (_passwordTextField.text.length >= 6 && _passwordTextField.text.length <= 20) {
        _verifyPassword = true;
    }
    
    if (_verifyTele && _verifyPassword) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        [[SPAuthBusinessUnit shareInstance] loginWithMobileByMobile:_teleTextfield.text password:_passwordTextField.text successful:^(SPUserInfoModel *model) {
            
            if (!model) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                [self loginRongCloudServerWithToken:model.token];
            }

        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
            });
        }];
        
    } else {
        if (!_verifyTele) {
            NSLog(@"请填写正确的手机号");
            [SPGlobalConfig showTextOfHUD:@"手机号有误" ToView:self.view];
        } else if (!_verifyPassword) {
            [SPGlobalConfig showTextOfHUD:@"密码有误" ToView:self.view];
        }
    }
    
}

//点击返回注册
- (void)registerAction:(id)sender {
//    for (UIViewController *viewController in self.navigationController.viewControllers) {
//        if ([viewController isMemberOfClass:[SPLoginWayViewController class]]) {
//            [self.navigationController popToViewController:viewController animated:true];
//            break;
//        }
//    }
    
    SPRegisterViewController *registerViewController = [[SPRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewController animated:true];
    
}

//点击忘记密码
- (void)passwordAction:(id)sender {
    SPForgetPasswordViewController *forgetPasswordViewController = [[SPForgetPasswordViewController alloc] init];
    [self presentViewController:forgetPasswordViewController animated:true completion:nil];
}

//点击微信登录
- (IBAction)weChatLoginAction:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        [WXApiRequestHandler sendAuthRequestScope:@"snsapi_userinfo"
                                            State:@"sportspage"
                                           OpenID:@""
                                 InViewController:self];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有安装微信" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

- (IBAction)qqLoginAction:(id)sender {
    if ([TencentOAuth iphoneQQInstalled]) {
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:KEY_TENCENT andDelegate:self];
        NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO];
        [_tencentOAuth authorize:permissions];
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有安装QQ" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if(response.errCode == 0) {
        NSLog(@"用户同意授权");
        [self getAccesToken:response.code];
    } else if(response.errCode == -2) {
        NSLog(@"用户取消授权");
    } else if(response.errCode == -4) {
        NSLog(@"用户拒绝授权");
    } else {
        NSLog(@"todo");
    }
}

-(void)getAccesToken:(NSString *)code {
    NSString* base = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code";
    NSString *url =[NSString stringWithFormat:base,KEY_WEIXIN,KEY_SECRET,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSString *access_token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                NSString *unionid = dic[@"unionid"];
                
                [[SPAuthBusinessUnit shareInstance] checkWxRegisterWithOpenid:openid successful:^(NSString *successsfulString) {
                    if ([successsfulString isEqualToString:@"600"]) {
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        [self getUserInfo:access_token withOpenId:openid];
                    } else if ([successsfulString isEqualToString:@"200"]) {
                        
                        [[SPAuthBusinessUnit shareInstance] registerWithWeChatByUnionId:unionid openid:openid successful:^(NSString *successsfulString) {
                            
                            if ([successsfulString isEqualToString:@"600"] || [successsfulString isEqualToString:@"200"]) {
                                
                                [[SPAuthBusinessUnit shareInstance] loginWithWeChatByOpenid:openid successful:^(SPUserInfoModel *model) {
                                    if (model) {
                                        [MBProgressHUD hideHUDForView:self.view animated:true];
                                        [self loginRongCloudServerWithToken:model.token];
                                    } else {
                                        [MBProgressHUD hideHUDForView:self.view animated:true];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                                        });
                                    }
                                } failure:^(NSString *errorString) {
                                    NSLog(@"%@",successsfulString);
                                    NSLog(@"loginWithWeChatByOpenid AFN ERROR");
                                    [MBProgressHUD hideHUDForView:self.view animated:true];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                                    });
                                }];
                            } else {
                                NSLog(@"%@",successsfulString);
                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                                });
                            }
                            
                        } failure:^(NSString *errorString) {
                            NSLog(@"registerWithWeChatByUnionId AFN ERROR");
                            NSLog(@"%@",successsfulString);
                            [MBProgressHUD hideHUDForView:self.view animated:true];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                            });
                        }];
                        
                    } else {
                        NSLog(@"%@",successsfulString);
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                        });
                    }
                } failure:^(NSString *errorString) {
                    NSLog(@"checkWxRegisterWithOpenid AFN ERROR");
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    });
                }];
            } else {
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            }
        });
    });
}

//通过AccessToken获取用户信息
-(void)getUserInfo:(NSString *)access_token withOpenId:(NSString *)openid {
    NSString* base = @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@";
    NSString *url =[NSString stringWithFormat:base,access_token,openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *jsonStr = [self DataTOjsonString:dic];
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                [[SPAuthBusinessUnit shareInstance] addWxclientWithJsonStr:jsonStr openid:openid successful:^(NSString *successsfulString) {
                    if ([successsfulString isEqualToString:@"200"]) {
                        
                        [[SPAuthBusinessUnit shareInstance] registerWithWeChatByUnionId:dic[@"unionid"] openid:openid successful:^(NSString *successsfulString) {
                            
                            if ([successsfulString isEqualToString:@"200"] || [successsfulString isEqualToString:@"600"]) {
                                [[SPAuthBusinessUnit shareInstance] loginWithWeChatByOpenid:openid successful:^(SPUserInfoModel *model) {
                                    
                                    if (model) {
                                        [MBProgressHUD hideHUDForView:self.view animated:true];
                                        [self loginRongCloudServerWithToken:model.token];
                                    } else {
                                        [MBProgressHUD hideHUDForView:self.view animated:true];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                                        });
                                    }
                                    
                                } failure:^(NSString *errorString) {
                                    NSLog(@"loginWithWeChatByOpenid AFN ERROR");
                                    NSLog(@"%@",successsfulString);
                                    [MBProgressHUD hideHUDForView:self.view animated:true];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                                    });
                                }];
                            } else {
                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [SPGlobalConfig showTextOfHUD:@"注册失败" ToView:self.view];
                                });
                            }
                            
                        } failure:^(NSString *errorString) {
                            NSLog(@"registerWithWeChatByUnionId AFN ERROR");
                            [MBProgressHUD hideHUDForView:self.view animated:true];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                            });
                        }];
                    } else {
                        NSLog(@"%@",successsfulString);
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                        });
                    }
                } failure:^(NSString *errorString) {
                    NSLog(@"addWxclientWithJsonStr AFN ERROR");
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                    });
                }];
                
            }
        });
    });
}

- (NSString*)DataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string {
    
    if (textField == _teleTextfield) {
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
    [_teleTextfield resignFirstResponder];
    [_passwordTextField resignFirstResponder];
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
        NSLog(@"登陆的错误码为:%ld", (long)status);
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

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken.length != 0) {
        [_tencentOAuth getUserInfo];
    } else {
        [SPGlobalConfig showTextOfHUD:@"获取用户信息失败" ToView:self.view];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"用户登录取消");
    } else {
        [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
    }
}

- (void)tencentDidNotNetWork {
    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
}

- (void)getUserInfoResponse:(APIResponse *) response {
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        NSLog(@"json:%@",response.jsonResponse);
        
        [self tencentAction:response];
        
    } else {
        [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
    }
}

- (void)tencentAction:(APIResponse *)response {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [[SPAuthBusinessUnit shareInstance] checkQQRegisterWithOpenid:_tencentOAuth.openId successful:^(NSString *successsfulString) {
        
        if ([successsfulString isEqualToString:@"600"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            
            [self getQQUserInfo:response.jsonResponse];
            
        } else if ([successsfulString isEqualToString:@"200"]) {
            
            [[SPAuthBusinessUnit shareInstance] registerWithQQByOpenid:_tencentOAuth.openId successful:^(NSString *successsfulString) {
                
                if ([successsfulString isEqualToString:@"600"] || [successsfulString isEqualToString:@"200"]) {
                    
                    [[SPAuthBusinessUnit shareInstance] loginWithQQByOpenid:_tencentOAuth.openId successful:^(SPUserInfoModel *model) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        [self loginRongCloudServerWithToken:model.token];
                        
                    } failure:^(NSString *errorString) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                        });
                        
                    }];
                    
                } else {
                    
                    NSLog(@"%@",successsfulString);
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                    });
                    
                }
                
            } failure:^(NSString *errorString) {
                NSLog(@"registerWithQQByOpenid AFN ERROR");
                NSLog(@"%@",successsfulString);
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
            
        } else {
            NSLog(@"%@",successsfulString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }
        
    } failure:^(NSString *errorString) {
        NSLog(@"checkQQRegisterWithOpenid AFN ERROR");
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
    
}

- (void)getQQUserInfo:(NSDictionary *)jsonDic {
    
    NSString *jsonStr = [self DataTOjsonString:jsonDic];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [[SPAuthBusinessUnit shareInstance] addQQclientWithJsonStr:jsonStr openid:_tencentOAuth.openId successful:^(NSString *successsfulString) {
        
        if ([successsfulString isEqualToString:@"200"]) {
            
            [[SPAuthBusinessUnit shareInstance] registerWithQQByOpenid:_tencentOAuth.openId successful:^(NSString *successsfulString) {
                
                if ([successsfulString isEqualToString:@"200"] || [successsfulString isEqualToString:@"600"]) {
                    
                    [[SPAuthBusinessUnit shareInstance] loginWithQQByOpenid:_tencentOAuth.openId successful:^(SPUserInfoModel *model) {
                        
                        if (model) {
                            [MBProgressHUD hideHUDForView:self.view animated:true];
                            [self loginRongCloudServerWithToken:model.token];
                        } else {
                            [MBProgressHUD hideHUDForView:self.view animated:true];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [SPGlobalConfig showTextOfHUD:@"登录失败" ToView:self.view];
                            });
                        }
                        
                    } failure:^(NSString *errorString) {
                        NSLog(@"loginWithQQByOpenid AFN ERROR");
                        NSLog(@"%@",successsfulString);
                        [MBProgressHUD hideHUDForView:self.view animated:true];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                        });
                    }];
                    
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:true];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SPGlobalConfig showTextOfHUD:@"注册失败" ToView:self.view];
                    });
                }
                
            } failure:^(NSString *errorString) {
                NSLog(@"registerWithQQByOpenid AFN ERROR");
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
                });
            }];
            
        } else {
            NSLog(@"%@",successsfulString);
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }
        
    } failure:^(NSString *errorString) {
        NSLog(@"addQQclientWithJsonStr AFN ERROR");
        [MBProgressHUD hideHUDForView:self.view animated:true];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        });
    }];
    
}

@end
