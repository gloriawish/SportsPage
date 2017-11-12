//
//  SPCreateEventView.m
//  SportsPage
//
//  Created by Qin on 2016/11/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateEventView.h"

@interface SPCreateEventView ()

@property (weak, nonatomic) IBOutlet UIButton *badmintonButton;
@property (weak, nonatomic) IBOutlet UIButton *footballButton;
@property (weak, nonatomic) IBOutlet UIButton *basketballButton;
@property (weak, nonatomic) IBOutlet UIButton *tennisButton;
@property (weak, nonatomic) IBOutlet UIButton *joggingButton;
@property (weak, nonatomic) IBOutlet UIButton *swimmingButton;
@property (weak, nonatomic) IBOutlet UIButton *squashButton;
@property (weak, nonatomic) IBOutlet UIButton *kayakButton;
@property (weak, nonatomic) IBOutlet UIButton *baseballButton;
@property (weak, nonatomic) IBOutlet UIButton *pingpangButton;

@property (weak, nonatomic) IBOutlet UIButton *customButton;

@end

@implementation SPCreateEventView

- (void)awakeFromNib {
    [super awakeFromNib];
    _customButton.layer.cornerRadius = 5;
    _customButton.layer.masksToBounds = true;
    [_customButton setBackgroundColor:[SPGlobalConfig themeColor]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_selectedEventView];
    
    if (!CGRectContainsPoint(_selectedEventView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _selectedEventView.alpha = 0;
            _createSportsViewController.windowImageView.alpha = 0;
            _createSportsViewController.navigationController.navigationBar.alpha = 1;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_createSportsViewController.windowImageView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

- (IBAction)selectedButtonAction:(UIButton *)sender {
    
    if (sender == _badmintonButton) {
        _createSportsViewController.eventTextField.text = @"羽毛球";
    } else if (sender == _footballButton) {
        _createSportsViewController.eventTextField.text = @"足球";
    } else if (sender == _basketballButton) {
        _createSportsViewController.eventTextField.text = @"篮球";
    } else if (sender == _tennisButton) {
        _createSportsViewController.eventTextField.text = @"网球";
    } else if (sender == _joggingButton) {
        _createSportsViewController.eventTextField.text = @"跑步";
    } else if (sender == _swimmingButton) {
        _createSportsViewController.eventTextField.text = @"游泳";
    } else if (sender == _squashButton) {
        _createSportsViewController.eventTextField.text = @"壁球";
    } else if (sender == _kayakButton) {
        _createSportsViewController.eventTextField.text = @"皮划艇";
    } else if (sender == _baseballButton) {
        _createSportsViewController.eventTextField.text = @"棒球";
    } else if (sender == _pingpangButton) {
        _createSportsViewController.eventTextField.text = @"乒乓";
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _selectedEventView.alpha = 0;
        _createSportsViewController.windowImageView.alpha = 0;
        _createSportsViewController.navigationController.navigationBar.alpha = 1;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createSportsViewController.windowImageView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}


- (IBAction)customButtonAction:(id)sender {
    _createSportsViewController.eventShowKeyboard = true;
    [_createSportsViewController.eventTextField becomeFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        _selectedEventView.alpha = 0;
        _createSportsViewController.windowImageView.alpha = 0;
        _createSportsViewController.navigationController.navigationBar.alpha = 1;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createSportsViewController.windowImageView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

- (IBAction)exitButtonAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _selectedEventView.alpha = 0;
        _createSportsViewController.windowImageView.alpha = 0;
        _createSportsViewController.navigationController.navigationBar.alpha = 1;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createSportsViewController.windowImageView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


@end
