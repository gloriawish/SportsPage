//
//  SPPersonalAccountViewController.m
//  SportsPage
//
//  Created by Qin on 2016/11/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountViewController.h"

#import "SPPersonalAccountWithDrawViewController.h"
#import "SPPersonalAccountDefiniteViewController.h"
#import "SPPersonalAccountTopUpViewController.h"
#import "SPPersonalUpdatePasswordViewController.h"

#import "SPPINGBusinessUnit.h"

@interface SPPersonalAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIView *topUpView;
@property (weak, nonatomic) IBOutlet UIView *withDrawView;
@property (weak, nonatomic) IBOutlet UIView *keepAccountView;

@end

@implementation SPPersonalAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _balanceLabel.text = @"0.00";
    
    [self setAttributedText:_balanceLabel.text];
    
//    if (_balanceStr.length != 0) {
//        _balanceLabel.text = _balanceStr;
//        NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc] initWithString:_balanceStr];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:70] range:NSMakeRange(0, _balanceStr.length-3)];
//        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(_balanceStr.length-3, 3)];
//        [_balanceLabel setAttributedText:attributedString];
//    } else {
//        _balanceLabel.text = @"0";
//    }
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    [self addGesture:_topUpView];
    [self addGesture:_withDrawView];
    [self addGesture:_keepAccountView];
}

- (void)addGesture:(UIView *)sender {
    sender.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [sender addGestureRecognizer:gesture];
}

- (void)setAttributedText:(NSString *)content {
    NSMutableAttributedString *attributedString  = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:70] range:NSMakeRange(0, content.length-3)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(content.length-3, 3)];
    [_balanceLabel setAttributedText:attributedString];
}

#pragma mark - NetworkRequest
- (void)networkRequest {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPPINGBusinessUnit shareInstance] getAccountInfoWithUserId:userId successful:^(NSDictionary *dic) {
        if (dic) {
            [self setAttributedText:dic[@"balance"]];
        } else {
            [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
        }
    } failure:^(NSString *errorString) {
        [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
    }];
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self .navigationController popViewControllerAnimated:true];
}

- (IBAction)navSettingAction:(id)sender {
    SPPersonalUpdatePasswordViewController *rePasswordViewController = [[SPPersonalUpdatePasswordViewController alloc] init];
    rePasswordViewController.titleStr = @"修改支付密码";
    rePasswordViewController.passwordNameStr = @"支付密码";
    [self.navigationController pushViewController:rePasswordViewController animated:true];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (sender.view == _topUpView) {
        SPPersonalAccountTopUpViewController *topUpViewController = [[SPPersonalAccountTopUpViewController alloc] init];
        [self.navigationController pushViewController:topUpViewController animated:true];
    } else if (sender.view == _withDrawView) {
        SPPersonalAccountWithDrawViewController *withDrawViewController = [[SPPersonalAccountWithDrawViewController alloc] init];
        withDrawViewController.contentStr = _balanceStr;
        [self.navigationController pushViewController:withDrawViewController animated:true];
    } else {
        SPPersonalAccountDefiniteViewController *definiteViewController = [[SPPersonalAccountDefiniteViewController alloc] init];
        [self.navigationController pushViewController:definiteViewController animated:true];
    }
}

@end
