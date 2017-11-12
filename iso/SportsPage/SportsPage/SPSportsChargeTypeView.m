//
//  SPSportsChargeTypeView.m
//  SportsPage
//
//  Created by Qin on 2016/11/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsChargeTypeView.h"
#import "SPSportsOrderFinishedViewController.h"

#import "SPPINGBusinessUnit.h"
#import "Pingpp.h"

#import "MBProgressHUD.h"

#import "SPPersonalUpdatePasswordViewController.h"

//修改AppDelegate的pingppResult
#import "AppDelegate.h"

@interface SPSportsChargeTypeView () {
    NSInteger _payTypeNum;
}

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountBalanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accountSelImageView;
@property (weak, nonatomic) IBOutlet UIView *accountLineView;

@property (weak, nonatomic) IBOutlet UIView *weChatView;
@property (weak, nonatomic) IBOutlet UIImageView *weChatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weChatSelImageView;
@property (weak, nonatomic) IBOutlet UIView *weChatLineView;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@end

@implementation SPSportsChargeTypeView

- (void)awakeFromNib {
    [super awakeFromNib];
    _payButton.layer.cornerRadius = 5;
    _payButton.layer.masksToBounds = true;
    [_payButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _chargeTypeView.layer.cornerRadius = 10;
    _chargeTypeView.layer.masksToBounds = true;
    
    _priceLabel.textColor = [SPGlobalConfig themeColor];
    
    _weChatLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    _accountLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:239 alpha:1];
    
    [self addGesture:_accountView];
    [self addGesture:_weChatView];
}

- (void)addGesture:(UIView *)sender {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChargeType:)];
    [sender addGestureRecognizer:tapGesture];
}

- (void)selectChargeType:(UITapGestureRecognizer *)sender {
    if (sender.view == _accountView && _payTypeNum == 2) {
        _payTypeNum = 1;
        _weChatImageView.image = [UIImage imageNamed:@"Sports_chargeType_wechat_nor"];
        _weChatSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_nor"];
        
        _accountImageView.image = [UIImage imageNamed:@"Sports_chargeType_account_sel"];
        _accountSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_sel"];
    } else if (sender.view == _weChatView && _payTypeNum == 1) {
        _payTypeNum = 2;
        _accountImageView.image = [UIImage imageNamed:@"Sports_chargeType_account_nor"];
        _accountSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_nor"];
        
        _weChatImageView.image = [UIImage imageNamed:@"Sports_chargeType_wechat_sel"];
        _weChatSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_sel"];
    }
}

- (void)setUpWithBalance:(NSString *)balance price:(NSString *)price {
    _priceLabel.text = price;
    NSInteger typeNum = 0;
    
    if ([balance doubleValue] >= [price doubleValue]) {
        typeNum = 1;
    } else {
        typeNum = 2;
    }
    
    if (typeNum == 1) {
        _payTypeNum = 1;
        _accountImageView.image = [UIImage imageNamed:@"Sports_chargeType_account_sel"];
        _accountSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_sel"];
        _accountBalanceLabel.text = [NSString stringWithFormat:@"账户余额 %@",balance];
    } else if (typeNum == 2) {
        _payTypeNum = 2;
        _accountBalanceLabel.text = @"账户余额不足";
        _weChatImageView.image = [UIImage imageNamed:@"Sports_chargeType_wechat_sel"];
        _weChatSelImageView.image = [UIImage imageNamed:@"Sports_chargeType_view_sel"];
    }
}

- (IBAction)payAction:(UIButton *)sender {
    if (_payTypeNum == 1) {
        if ([_needPaypass integerValue] == 0) {
            SPPersonalUpdatePasswordViewController *rePasswordViewController = [[SPPersonalUpdatePasswordViewController alloc] init];
            rePasswordViewController.titleStr = @"设置支付密码";
            rePasswordViewController.passwordNameStr = @"支付密码";
            [_sportsOrderViewController.navigationController pushViewController:rePasswordViewController animated:true];
            [_sportsOrderViewController.windowImageView removeFromSuperview];
            [self removeFromSuperview];
        } else if ([_needPaypass integerValue] == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                _chargeTypeView.alpha = 0;
                _sportsOrderViewController.windowImageView.alpha = 0;
                self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
                [_sportsOrderViewController.windowImageView removeFromSuperview];
                [self removeFromSuperview];
                
                NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_ORDER_PAYPASS
                                                                    object:nil
                                                                  userInfo:@{@"userId":userId,
                                                                             @"orderNo":_orderNo,
                                                                             @"price":_priceLabel.text}];
            }];
        }
        
    } else if (_payTypeNum == 2) {
        [MBProgressHUD showHUDAddedTo:self animated:true];
        [[SPPINGBusinessUnit shareInstance] getPaymentChargeWithchannel:@"wx" orderNo:_orderNo successful:^(NSDictionary *dic) {
            if (dic) {
                [MBProgressHUD hideHUDForView:self animated:true];
                NSString *charge = dic[@"charge"];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                delegate.pingppResult = @"付款";
                [Pingpp createPayment:charge appURLScheme:KEY_WEIXIN withCompletion:^(NSString *result, PingppError *error) {
                    if (!error) {
                        NSLog(@"%@",result);
                        SPSportsOrderFinishedViewController *finishedViewController = [[SPSportsOrderFinishedViewController alloc] init];
                        [_sportsOrderViewController.navigationController pushViewController:finishedViewController animated:true];
                    } else {
                        NSLog(@"errorCode:%lu,errorMsg:%@",(unsigned long)error.code,[error getMsg]);
                        [SPGlobalConfig showTextOfHUD:[error getMsg] ToView:self];
                    }
                }];
            } else {
                [MBProgressHUD hideHUDForView:self animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self];
                });
            }
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self];
            });
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_chargeTypeView];
    
    if (!CGRectContainsPoint(_chargeTypeView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _chargeTypeView.alpha = 0;
            _sportsOrderViewController.windowImageView.alpha = 0;
            _sportsOrderViewController.navigationController.navigationBar.alpha = 1;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_sportsOrderViewController.windowImageView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

@end
