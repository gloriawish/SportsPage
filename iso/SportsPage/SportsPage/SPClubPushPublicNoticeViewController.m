//
//  SPClubPushPublicNoticeViewController.m
//  SportsPage
//
//  Created by Qin on 2017/2/17.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPClubPushPublicNoticeViewController.h"

#import "SPSportBusinessUnit.h"

#import "MBProgressHUD.h"

#import "SPPersonalClubViewController.h"
#import "SPSportsClubViewController.h"

@interface SPClubPushPublicNoticeViewController () <UITextViewDelegate> {
    UILabel *_textViewPlaceholder;
}

@property (weak, nonatomic) IBOutlet UILabel *viewControllerTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *clubPushPublicNoticeTextView;

@property (weak, nonatomic) IBOutlet UIButton *clubPushPublicNoticeButton;

@property (weak, nonatomic) IBOutlet UIButton *clubSkipButton;

@end

@implementation SPClubPushPublicNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    _viewControllerTitleLabel.text = _viewControllerTitle;
    
    if ([_viewControllerTitle isEqualToString:@"更新公告"]) {
        _clubSkipButton.hidden = true;
    } else {
        [_clubSkipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    
    _clubPushPublicNoticeButton.layer.cornerRadius = 5;
    _clubPushPublicNoticeButton.layer.masksToBounds = true;
    [_clubPushPublicNoticeButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_clubPushPublicNoticeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self setUpTextView];
}

- (void)setUpTextView {
    _textViewPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 6+64, SCREEN_WIDTH, 75)];
    _textViewPlaceholder.text = @"点击输入公告内容";
    _textViewPlaceholder.textAlignment = NSTextAlignmentCenter;
    _textViewPlaceholder.textColor = [SPGlobalConfig anyColorWithRed:135 green:135 blue:135 alpha:1];
    [self.view addSubview:_textViewPlaceholder];
    
    _clubPushPublicNoticeTextView.delegate = self;
    _clubPushPublicNoticeTextView.returnKeyType = UIReturnKeyDone;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)clubSkipAction:(UIButton *)sender {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isMemberOfClass:[SPPersonalClubViewController class]]) {
            [self.navigationController popToViewController:viewController animated:false];
            
            SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
            clubViewController.clubId = _clubId;
            [viewController.navigationController pushViewController:clubViewController animated:true];
            break;
        }
    }
}


- (IBAction)pushPublicNotice:(id)sender {
    
    if (_clubPushPublicNoticeTextView.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请填写公告" ToView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] pushPublicNoticeWithUserId:userId clubId:_clubId content:_clubPushPublicNoticeTextView.text successful:^(NSString *successsfulString) {
        
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([_viewControllerTitle isEqualToString:@"更新公告"]) {
                    [SPGlobalConfig showTextOfHUD:@"公告已更新" ToView:self.view];
                    
                    if ([_delegate respondsToSelector:@selector(updatePublicNotice:)]) {
                        [_delegate updatePublicNotice:_clubPushPublicNoticeTextView.text];
                    }
                    
                    [self.navigationController popViewControllerAnimated:true];
                    
                } else if ([_viewControllerTitle isEqualToString:@"发布第一条公告"]) {
                    [SPGlobalConfig showTextOfHUD:@"公告已发布,俱乐部创建成功" ToView:self.view];
                    
                    for (UIViewController *viewController in self.navigationController.viewControllers) {
                        if ([viewController isMemberOfClass:[SPPersonalClubViewController class]]) {
                            [self.navigationController popToViewController:viewController animated:false];
                            
                            SPSportsClubViewController *clubViewController = [[SPSportsClubViewController alloc] init];
                            clubViewController.clubId = _clubId;
                            [viewController.navigationController pushViewController:clubViewController animated:true];
                            break;
                        }
                    }
                    
                    
                }
                
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _textViewPlaceholder.hidden = true;
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (_clubPushPublicNoticeTextView.text.length == 0) {
        _textViewPlaceholder.hidden = false;
    }
    return true;
}

#pragma mark - TouchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_clubPushPublicNoticeTextView isFirstResponder]) {
        [_clubPushPublicNoticeTextView resignFirstResponder];
    }
}

@end
