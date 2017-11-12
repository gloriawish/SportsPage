//
//  SPPersonalClubInfoUpdateViewController.m
//  SportsPage
//
//  Created by Qin on 2017/3/24.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubInfoUpdateViewController.h"

//EventView
#import "SPCreateSportsPageEventView.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPPersonalClubInfoUpdateViewController () <UITextFieldDelegate,SPCreateSportsPageEventViewProtocol> {
    SPPersonalClubInfoUpdateViewControllerStyle _style;
    NSString *_clubId;
    NSString *_sourceString;
    
    BOOL _showEventKeyBoard;
    UIImageView *_windowImageView;
    SPCreateSportsPageEventView *_createSportsPageEventView;
}

@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *navFinishedButton;

@property (weak, nonatomic) IBOutlet UITextField *updateTextField;

@end

@implementation SPPersonalClubInfoUpdateViewController

- (instancetype)initWithStyle:(SPPersonalClubInfoUpdateViewControllerStyle)style
                 sourceString:(NSString *)sourceString
                       clubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        _style = style;
        _sourceString = sourceString;
        _clubId = clubId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    [_navFinishedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    _updateTextField.delegate = self;
    _updateTextField.text = _sourceString;
    
    if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubName) {
        _navTitleLabel.text = @"修改俱乐部名称";
    } else if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubEvent) {
        _navTitleLabel.text = @"修改俱乐部项目";
    }
    
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)navFinishedAction:(id)sender {
    
    if ([_updateTextField isFirstResponder]) {
        [_updateTextField resignFirstResponder];
    }
    
    if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubName) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        [[SPSportBusinessUnit shareInstance] updateClubNameWithUserId:userId clubId:_clubId name:_updateTextField.text successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"更新成功" ToView:self.view];
                    
                    if ([_delegate respondsToSelector:@selector(finishedUpdateClubNameAction:)]) {
                        [_delegate finishedUpdateClubNameAction:_updateTextField.text];
                    }
                    
                    [self.navigationController popViewControllerAnimated:true];
                });
                
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                });
            }
            
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];

    } else if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubEvent) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
        
        NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        
        NSString *sportsItem = nil;
        NSString *sportsExtend = nil;
        
        if ([_updateTextField.text isEqualToString:@"羽毛球"]) {
            sportsItem = @"1";
        } else if ([_updateTextField.text isEqualToString:@"足球"]) {
            sportsItem = @"2";
        } else if ([_updateTextField.text isEqualToString:@"篮球"]) {
            sportsItem = @"3";
        } else if ([_updateTextField.text isEqualToString:@"网球"]) {
            sportsItem = @"4";
        } else if ([_updateTextField.text isEqualToString:@"跑步"]) {
            sportsItem = @"5";
        } else if ([_updateTextField.text isEqualToString:@"游泳"]) {
            sportsItem = @"6";
        } else if ([_updateTextField.text isEqualToString:@"壁球"]) {
            sportsItem = @"7";
        } else if ([_updateTextField.text isEqualToString:@"皮划艇"]) {
            sportsItem = @"8";
        } else if ([_updateTextField.text isEqualToString:@"棒球"]) {
            sportsItem = @"9";
        } else if ([_updateTextField.text isEqualToString:@"乒乓"]) {
            sportsItem = @"10";
        } else {
            sportsItem = @"20";
            sportsExtend = _updateTextField.text;
        }
        
        
        [[SPSportBusinessUnit shareInstance] updateClubEventWithUserId:userId clubId:_clubId sportItem:sportsItem sportItemExtend:sportsExtend successful:^(NSString *successsfulString) {
            
            if ([successsfulString isEqualToString:@"successful"]) {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:@"更新成功" ToView:self.view];
                    
                    if ([_delegate respondsToSelector:@selector(finishedUpdateClubEventAction:clubEventNum:)]) {
                        [_delegate finishedUpdateClubEventAction:_updateTextField.text clubEventNum:sportsItem];
                    }
                    
                    [self.navigationController popViewControllerAnimated:true];
                });
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:true];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SPGlobalConfig showTextOfHUD:successsfulString ToView:self.view];
                });
            }
            
        } failure:^(NSString *errorString) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"网络请求失败" ToView:self.view];
            });
        }];
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubName) {
        return true;
    } else if (_style == SPPersonalClubInfoUpdateViewControllerStyleUpdateClubEvent) {
        if (!_showEventKeyBoard) {
            
            if ([_updateTextField isFirstResponder]) {
                [_updateTextField resignFirstResponder];
            }
            
            if (!_windowImageView) {
                _windowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                _windowImageView.image = [UIImage imageNamed:@"Sports_create_windowBG"];
                _windowImageView.alpha = 0;
            }
            [self.view addSubview:_windowImageView];
            
            if (!_createSportsPageEventView) {
                _createSportsPageEventView = [[[NSBundle mainBundle] loadNibNamed:@"SPCreateSportsPageEventView" owner:nil options:nil] lastObject];
                _createSportsPageEventView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
                _createSportsPageEventView.delegate = self;
            }
            [self.view addSubview:_createSportsPageEventView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _windowImageView.alpha = 1;
                _createSportsPageEventView.eventView.alpha = 1;
                _createSportsPageEventView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }];
            
            return false;
            
        } else {
            _showEventKeyBoard = false;
            return true;
        }
    } else {
        return true;
    }

}

#pragma mark - SPCreateSportsPageEventViewProtocol
- (void)receivedContentString:(NSString *)string {
    
    [UIView animateWithDuration:0.5 animations:^{
        _windowImageView.alpha = 0;
        _createSportsPageEventView.eventView.alpha = 0;
        _createSportsPageEventView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        _windowImageView.alpha = 1;
        [_windowImageView removeFromSuperview];
        _createSportsPageEventView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_createSportsPageEventView removeFromSuperview];
    }];
    
    if ([string isEqualToString:@"自定义"]) {
        _showEventKeyBoard = true;
        [_updateTextField becomeFirstResponder];
    } else if ([string isEqualToString:@"取消"]) {
        
    } else {
        _updateTextField.text = string;
    }

}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_updateTextField isFirstResponder]) {
        [_updateTextField resignFirstResponder];
    }
}


@end
