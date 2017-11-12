
//
//  SPSportsAppraiseViewController.m
//  SportsPage
//
//  Created by Qin on 2016/12/8.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsAppraiseViewController.h"

#import "SPSportBusinessUnit.h"

#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import "SPSportsEventViewController.h"

@interface SPSportsAppraiseViewController () <UITextViewDelegate,StarRatingViewDelegate> {
    UIImage *_image;
    NSString *_imageUrl;
    NSString *_titleStr;
    NSString *_locationStr;
    NSString *_timeStr;
    NSString *_initiateStr;
    NSString *_eventId;
    
    CGFloat _keyboardHeight;
    NSTimeInterval _animationDuration;
    //CGRect _scrollViewFrame;
    
    NSString *_grade;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;

@property (weak, nonatomic) IBOutlet TQStarRatingView *starRatingView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

@implementation SPSportsAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappearAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)updateViewConstraints {
    
    CGFloat fixConstant = SCREEN_WIDTH*9/16 + 130 + 6 + 75 + 6 + 75;
    if (fixConstant < SCREEN_HEIGHT-64) {
        fixConstant = SCREEN_HEIGHT-64;
    }
    
    _contentSizeHeightConstraint.constant = fixConstant;
    [super updateViewConstraints];
}

#pragma mark - SetUp
- (void)setUp {
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
    
    _scrollViewContentView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    if (_image) {
        _headImageView.image = _image;
    } else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    }
    
    _titleLabel.text = _titleStr;
    
    _locationLabel.textColor = [UIColor grayColor];
    _timeLabel.textColor = [UIColor grayColor];
    _initiateLabel.textColor = [UIColor grayColor];
    _locationLabel.text = _locationStr;
    _timeLabel.text = _timeStr;
    _initiateLabel.text = _initiateStr;
    
    _textView.delegate = self;
    _placeholderLabel.textColor = [UIColor grayColor];

    [_postButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAction)];
    [_scrollViewContentView addGestureRecognizer:tap];
    
    _starRatingView.delegate = self;
    
    _grade = @"3";
    [_starRatingView setScore:0.5 withAnimation:false];
}

- (void)setUpWithImage:(UIImage *)image
                 title:(NSString *)title
              location:(NSString *)location
                  time:(NSString *)time
              initiate:(NSString *)initiate
               eventId:(NSString *)eventId
              imageUrl:(NSString *)imageUrl {
    
    _eventId = eventId;
    if (image) {
        _image = image;
    } else {
        _image = nil;
        _imageUrl = imageUrl;
    }
    _titleStr = title;
    _locationStr = location;
    if (time.length >= 3) {
        _timeStr = [time substringWithRange:NSMakeRange(0, time.length-3)];
    } else {
        _timeStr = time;
    }
    _initiateStr = initiate;
}

#pragma mark - Action
- (IBAction)navBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)postButtonAction:(UIButton *)sender {
    sender.userInteractionEnabled = false;
    if (_textView.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请填写评论内容" ToView:self.view];
        sender.userInteractionEnabled = true;
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view  animated:true];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    [[SPSportBusinessUnit shareInstance] postAppraiseWithUserId:userId eventId:_eventId grade:_grade content:_textView.text successful:^(NSString *successsfulString) {
        if ([successsfulString isEqualToString:@"successful"]) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SPGlobalConfig showTextOfHUD:@"评价成功" ToView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    __weak UIViewController *eventViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    if ([eventViewController isMemberOfClass:[SPSportsEventViewController class]]) {
                        [((SPSportsEventViewController *)eventViewController).signUpButton setTitle:@"已评价" forState:UIControlStateNormal];
                        [((SPSportsEventViewController *)eventViewController).signUpButton setBackgroundColor:[UIColor grayColor]];
                        ((SPSportsEventViewController *)eventViewController).signUpButton.userInteractionEnabled = false;
                        sender.userInteractionEnabled = true;
                        [self.navigationController popViewControllerAnimated:true];
                    } else {
                        [self.navigationController popViewControllerAnimated:true];
                    }
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

- (void)resignAction {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeholderLabel.hidden = true;
    return true;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (_textView.text.length == 0) {
        _placeholderLabel.hidden = false;
    }
    return true;
}

#pragma mark - StarRatingViewDelegate
-(void)starRatingView:(TQStarRatingView *)view score:(float)score {
    if (score <= 0) {
        _grade = @"0";
    } else if (0 < score && score <= 0.2) {
        _grade = @"1";
    } else if (0.2 < score && score <= 0.4) {
        _grade = @"2";
    } else if (0.4 < score && score <= 0.6) {
        _grade = @"3";
    } else if (0.6 < score && score <= 0.8) {
        _grade = @"4";
    } else if (0.8 < score) {
        _grade = @"5";
    }
}

#pragma mark - Keyboard
- (void)keyboardAppearAction:(NSNotification *)notification {
    if ([_textView isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        _keyboardHeight = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;
        [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] getValue:&_animationDuration];
        
        _topConstraint.constant = -_keyboardHeight;
        _bottomConstraint.constant = _keyboardHeight;
        
        [UIView animateWithDuration:_animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardDisappearAction:(NSNotification *)notification {
    if ([_textView isFirstResponder]) {
        _topConstraint.constant = 0;
        _bottomConstraint.constant = 0;
        
        [UIView animateWithDuration:_animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

@end
