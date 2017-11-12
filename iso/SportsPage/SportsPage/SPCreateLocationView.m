//
//  SPCreateLocationView.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateLocationView.h"

@interface SPCreateLocationView () <UITextFieldDelegate> {
    SPSportsCreateLocationResponseModel *_locationModel;
}

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *placeLocationTextField;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@end

@implementation SPCreateLocationView

- (void)awakeFromNib {
    [super awakeFromNib];
    _finishedButton.layer.cornerRadius = 5;
    _finishedButton.layer.masksToBounds = true;
    [_finishedButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _placeLocationTextField.delegate = self;
}

- (IBAction)finishedButtonAction:(UIButton *)sender {
    
    if (_placeLocationTextField.text.length == 0) {
        [SPGlobalConfig showTextOfHUD:@"请输入场馆名称" ToView:self];
        return;
    }
    
    if ([_placeLocationTextField isFirstResponder]) {
        [_placeLocationTextField resignFirstResponder];
    }
    
    if ([_createLocationViewController.delegate respondsToSelector:@selector(receiveDataWithName:address:latitude:longitude:)]) {
        [_createLocationViewController.delegate receiveDataWithName:_placeLocationTextField.text
                                                            address:_locationModel.address
                                                           latitude:_locationModel.latitude
                                                          longitude:_locationModel.longitude];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _selectedLocationView.alpha = 0;
        _createLocationViewController.windowImageView.alpha = 0;
        _createLocationViewController.navigationController.navigationBar.alpha = 1;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createLocationViewController.windowImageView removeFromSuperview];
        [self removeFromSuperview];
        [_createLocationViewController.navigationController popViewControllerAnimated:true];
    }];
}

- (void)setUpWithModel:(SPSportsCreateLocationResponseModel *)model {
    _locationModel = model;
    
    _placeNameLabel.text = model.address;
    if (model.name.length != 0) {
        _placeLocationTextField.text = model.name;
        //_placeLocationTextField.userInteractionEnabled = false;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_selectedLocationView];
    
    if (!CGRectContainsPoint(_selectedLocationView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _selectedLocationView.alpha = 0;
            _createLocationViewController.windowImageView.alpha = 0;
            _createLocationViewController.navigationController.navigationBar.alpha = 1;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_createLocationViewController.windowImageView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}


@end
