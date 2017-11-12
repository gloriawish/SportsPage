//
//  SPPersonalFeedbackViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalFeedbackViewController.h"

#import "SPUserBusinessUnit.h"

#import "MBProgressHUD.h"

@interface SPPersonalFeedbackViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (weak, nonatomic) IBOutlet UILabel *letterCountLabel;

@end

@implementation SPPersonalFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    self.view.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    _textView.delegate = self;
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = true;
    _textView.layer.borderWidth = 1;
    _textView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    
    _letterCountLabel.text = @"200";
    
    [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_finishedButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSMutableAttributedString *placeHolderAttributedString = [[NSMutableAttributedString alloc] initWithString:_placeHolderLabel.text];
    [placeHolderAttributedString addAttribute:NSParagraphStyleAttributeName
                                        value:paragraphStyle
                                        range:NSMakeRange(0, [_placeHolderLabel.text length])];
    _placeHolderLabel.attributedText = placeHolderAttributedString;

}

#pragma mark - Action
- (IBAction)finishedButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (_textView.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请填写内容" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPUserBusinessUnit shareInstance] addFeedbackWithUserId:userId content:_textView.text successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"反馈已发送成功" ToView:self.view];
                sender.userInteractionEnabled = true;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:true];
                });
            });
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
}

- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeHolderLabel.hidden = true;
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (_textView.text.length == 0) {
        _placeHolderLabel.hidden = false;
    }
    return true;
}

-(void)textViewDidChange:(UITextView *)textView {
    NSInteger count = 200 - textView.text.length;
    _letterCountLabel.text = [NSString stringWithFormat:@"%lu",(long)count];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([_letterCountLabel.text integerValue] <= 0) {
        return false;
    } else {
        return true;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}


@end
