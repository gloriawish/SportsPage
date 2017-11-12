//
//  SPCreateTimeView.m
//  SportsPage
//
//  Created by Qin on 2016/11/10.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateTimeView.h"

@interface SPCreateTimeView () <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSMutableArray *_hoursArray;
    NSMutableArray *_minutesArray;
    NSMutableArray *_timeArray;
    
    UILabel *_highlightLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel4;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation SPCreateTimeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = true;
    [_confirmButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    _timeLabel1.tag = 14;
    _timeLabel2.tag = 16;
    _timeLabel3.tag = 18;
    _timeLabel4.tag = 20;
    
    [self setUpWithLabel:_timeLabel1];
    [self setUpWithLabel:_timeLabel2];
    [self setUpWithLabel:_timeLabel3];
    [self setUpWithLabel:_timeLabel4];
    
    [self fillData];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [_pickerView selectRow:17 inComponent:0 animated:true];
    [_pickerView selectRow:2 inComponent:1 animated:true];
    [_pickerView selectRow:3 inComponent:2 animated:true];
}

- (void)setUpWithLabel:(UILabel *)sender {
    sender.layer.cornerRadius = 17.5;
    sender.layer.masksToBounds = true;
    sender.layer.borderColor = [UIColor blackColor].CGColor;
    sender.layer.borderWidth = 1;
    sender.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
    [sender addGestureRecognizer:tapGesture];
}

- (void)fillData {
    
    _hoursArray = [[NSMutableArray alloc] init];
    _minutesArray = [[NSMutableArray alloc] init];
    _timeArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<24; i++) {
        
        if (i == 0) {
            [_minutesArray addObject:[NSString stringWithFormat:@"%d分",i*10]];
        } else if (i>0 && i<4) {
            [_minutesArray addObject:[NSString stringWithFormat:@"%d分",i*15]];
            [_timeArray addObject:[NSString stringWithFormat:@"%.1f小时",i*0.5]];
        } else if (i>3) {
            [_timeArray addObject:[NSString stringWithFormat:@"%.1f小时",i*0.5]];
        }
        
        [_hoursArray addObject:[NSString stringWithFormat:@"%d点",i]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_timePickerView];
    
    if (!CGRectContainsPoint(_timePickerView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _timePickerView.alpha = 0;
            _createNextStepViewController.windowImageView.alpha = 0;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_createNextStepViewController.windowImageView removeFromSuperview];
            _createNextStepViewController.isSubWindowDisplay = false;
            [self removeFromSuperview];
        }];
    }
}

- (IBAction)confirmButtonAction:(UIButton *)sender {
    
    NSString *hourStr = _hoursArray[[_pickerView selectedRowInComponent:0]];
    NSString *minutesStr = _minutesArray[[_pickerView selectedRowInComponent:1]];
    NSString *timeStr = _timeArray[[_pickerView selectedRowInComponent:2]];
    hourStr = [hourStr substringWithRange:NSMakeRange(0, hourStr.length-1)];
    minutesStr = [minutesStr substringWithRange:NSMakeRange(0, minutesStr.length-1)];
    if (minutesStr.length == 1) {
        minutesStr = [NSString stringWithFormat:@"%@0",minutesStr];
    }
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    NSString *string = [NSString stringWithFormat:@"%@:%@  时长%@",hourStr,minutesStr,timeStr];
    
    [_createNextStepViewController.imageArray replaceObjectAtIndex:2 withObject:@"Sports_create_step2_time_blue"];
    if (!string) {
        [_createNextStepViewController.dataStringArray replaceObjectAtIndex:1 withObject:@""];
    } else {
        [_createNextStepViewController.dataStringArray replaceObjectAtIndex:1 withObject:string];
    }
    [_createNextStepViewController.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView animateWithDuration:0.5 animations:^{
        _timePickerView.alpha = 0;
        _createNextStepViewController.windowImageView.alpha = 0;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createNextStepViewController.windowImageView removeFromSuperview];
        _createNextStepViewController.isSubWindowDisplay = false;
        [self removeFromSuperview];
    }];
}

- (void)tapLabelAction:(UITapGestureRecognizer *)sender {
    UILabel *senderLabel = (UILabel *)sender.view;
    if (_highlightLabel != senderLabel) {
        if ([_pickerView selectedRowInComponent:0] != senderLabel.tag) {
            [_pickerView selectRow:senderLabel.tag inComponent:0 animated:true];
        }
        if ([_pickerView selectedRowInComponent:1] != 0) {
            [_pickerView selectRow:0 inComponent:1 animated:true];
        }
        _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _highlightLabel.textColor = [UIColor blackColor];
        senderLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        senderLabel.textColor = [SPGlobalConfig themeColor];
        _highlightLabel = senderLabel;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else if (component == 1) {
        return 4;
    } else {
        return 20;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _hoursArray[row];
    } else if (component == 1) {
        return _minutesArray[row];
    } else {
        return _timeArray[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return self.frame.size.width/4;
    } else if (component == 1) {
        return self.frame.size.width/4;
    } else {
        return self.frame.size.width/2;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger hourRow = [pickerView selectedRowInComponent:0];
    NSInteger minutesRow = [pickerView selectedRowInComponent:1];
    if (minutesRow != 0) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = nil;
        }
    } else {
        if (hourRow != 14 && hourRow != 16 && hourRow != 18 && hourRow != 20) {
            if (_highlightLabel) {
                _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
                _highlightLabel.textColor = [UIColor blackColor];
                _highlightLabel = nil;
            }
        } else {
            UILabel *selectedLabel = (UILabel *)[self viewWithTag:hourRow];
            if (_highlightLabel != selectedLabel) {
                _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
                _highlightLabel.textColor = [UIColor blackColor];
                selectedLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
                selectedLabel.textColor = [SPGlobalConfig themeColor];
                _highlightLabel = selectedLabel;
            }
        }
    }
}

@end
