//
//  SPSelectDateView.m
//  SportsPage
//
//  Created by Qin on 2016/11/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSelectDateView.h"

#import "Daysquare.h"

@interface SPSelectDateView () {
    UILabel *_highlightLabel;
    NSDateFormatter *_formatter;
}

@property (weak, nonatomic) IBOutlet DAYCalendarView *dayCalendarView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel3;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel4;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel5;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel6;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel7;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation SPSelectDateView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = true;
    [_confirmButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    [self borderHandle:_dateLabel1];
    [self borderHandle:_dateLabel2];
    [self borderHandle:_dateLabel3];
    [self borderHandle:_dateLabel4];
    [self borderHandle:_dateLabel5];
    [self borderHandle:_dateLabel6];
    [self borderHandle:_dateLabel7];
    
    [_dayCalendarView addTarget:self action:@selector(changeDateAction:) forControlEvents:UIControlEventValueChanged];
    _dayCalendarView.selectedDate = [NSDate date];
    
    [self judgingLabelText];
}

- (void)borderHandle:(UILabel *)sender {
    sender.layer.cornerRadius = 17.5;
    sender.layer.masksToBounds = true;
    sender.layer.borderColor = [UIColor blackColor].CGColor;
    sender.layer.borderWidth = 1;
    sender.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelAction:)];
    [sender addGestureRecognizer:tapGesture];
}

- (void)judgingLabelText {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDateStr = [_formatter stringFromDate:[NSDate dateWithTimeInterval:86400*3 sinceDate:[NSDate date]]];
    NSArray *dateArray = [nowDateStr componentsSeparatedByString:@"-"];
    NSString *weekStr = [self judgingDateTextWithYear:dateArray[0] month:dateArray[1] day:dateArray[2]];
    if ([weekStr isEqualToString:@"周一"]) {
        _dateLabel4.text = @"周一";
        _dateLabel5.text = @"周二";
        _dateLabel6.text = @"周三";
        _dateLabel7.text = @"周四";
    } else if ([weekStr isEqualToString:@"周二"]) {
        _dateLabel4.text = @"周二";
        _dateLabel5.text = @"周三";
        _dateLabel6.text = @"周四";
        _dateLabel7.text = @"周五";
    } else if ([weekStr isEqualToString:@"周三"]) {
        _dateLabel4.text = @"周三";
        _dateLabel5.text = @"周四";
        _dateLabel6.text = @"周五";
        _dateLabel7.text = @"周六";
    } else if ([weekStr isEqualToString:@"周四"]) {
        _dateLabel4.text = @"周四";
        _dateLabel5.text = @"周五";
        _dateLabel6.text = @"周六";
        _dateLabel7.text = @"周日";
    } else if ([weekStr isEqualToString:@"周五"]) {
        _dateLabel4.text = @"周五";
        _dateLabel5.text = @"周六";
        _dateLabel6.text = @"周日";
        _dateLabel7.text = @"周一";
    } else if ([weekStr isEqualToString:@"周六"]) {
        _dateLabel4.text = @"周六";
        _dateLabel5.text = @"周日";
        _dateLabel6.text = @"周一";
        _dateLabel7.text = @"周二";
    } else if ([weekStr isEqualToString:@"周日"]) {
        _dateLabel4.text = @"周日";
        _dateLabel5.text = @"周一";
        _dateLabel6.text = @"周二";
        _dateLabel7.text = @"周三";
    }
}

- (NSString *)judgingDateTextWithYear:(NSString *)yearStr month:(NSString *)monthStr day:(NSString *)dayStr {
    int year = [yearStr intValue];
    int month = [monthStr intValue];
    int day = [dayStr intValue];
    if (month == 1 || month == 2) {
        month += 12;
        year--;
    }
    int iWeek = (day+2*month+3*(month+1)/5+year+year/4-year/100+year/400)%7;
    NSString *weekString = nil;
    switch (iWeek) {
        case 0:
            weekString = @"周一";
            break;
        case 1:
            weekString = @"周二";
            break;
        case 2:
            weekString = @"周三";
            break;
        case 3:
            weekString = @"周四";
            break;
        case 4:
            weekString = @"周五";
            break;
        case 5:
            weekString = @"周六";
            break;
        case 6:
            weekString = @"周日";
            break;
        default:
            break;
    }
    return weekString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_dateSelectView];
    if (!CGRectContainsPoint(_dateSelectView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _dateSelectView.alpha = 0;
            _createNextStepViewController.windowImageView.alpha = 0;
            self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [_createNextStepViewController.windowImageView removeFromSuperview];
            _createNextStepViewController.isSubWindowDisplay = false;
            [self removeFromSuperview];
        }];
    }
}

- (void)tapLabelAction:(UITapGestureRecognizer *)sender {
    if (sender.view == _dateLabel1) {
        if (_highlightLabel != _dateLabel1) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel1;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate date];
    } else if (sender.view == _dateLabel2) {
        if (_highlightLabel != _dateLabel2) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel2;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
    } else if (sender.view == _dateLabel3) {
        if (_highlightLabel != _dateLabel3) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel3;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400*2 sinceDate:[NSDate date]];
    } else if (sender.view == _dateLabel4) {
        if (_highlightLabel != _dateLabel4) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel4;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400*3 sinceDate:[NSDate date]];
    } else if (sender.view == _dateLabel5) {
        if (_highlightLabel != _dateLabel5) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel5;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400*4 sinceDate:[NSDate date]];
    } else if (sender.view == _dateLabel6) {
        if (_highlightLabel != _dateLabel6) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel6;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400*5 sinceDate:[NSDate date]];
    } else if (sender.view == _dateLabel7) {
        if (_highlightLabel != _dateLabel7) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = _dateLabel7;
            _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
            _highlightLabel.textColor = [SPGlobalConfig themeColor];
        }
        _dayCalendarView.selectedDate = [NSDate dateWithTimeInterval:86400*6 sinceDate:[NSDate date]];
    }
}

- (IBAction)confirmButtonAction:(id)sender {
    NSDate *date = _dayCalendarView.selectedDate;
    if (!date) {
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:date];
    
    [_createNextStepViewController.imageArray replaceObjectAtIndex:1 withObject:@"Sports_create_step2_date_blue"];
    [_createNextStepViewController.dataStringArray replaceObjectAtIndex:0 withObject:string];
    [_createNextStepViewController.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView animateWithDuration:0.5 animations:^{
        _dateSelectView.alpha = 0;
        _createNextStepViewController.windowImageView.alpha = 0;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createNextStepViewController.windowImageView removeFromSuperview];
        _createNextStepViewController.isSubWindowDisplay = false;
        [self removeFromSuperview];
    }];
}

- (void)changeDateAction:(id)sender {
    NSInteger timeIntervalCalendar = (int)_dayCalendarView.selectedDate.timeIntervalSince1970;
    NSInteger timeIntervalNow = (int)[NSDate date].timeIntervalSince1970;
    NSInteger timeIntervalDiff = timeIntervalCalendar - timeIntervalNow;
    
    if (timeIntervalDiff <= -86400) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = nil;
        }
    } else if (timeIntervalDiff > -86400 && timeIntervalDiff <= 0) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel1;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 0 && timeIntervalDiff <= 86400) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel2;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 86400 && timeIntervalDiff <= 86400*2) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel3;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 86400*2 && timeIntervalDiff <= 86400*3) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel4;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 86400*3 && timeIntervalDiff <= 86400*4) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel5;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 86400*4 && timeIntervalDiff <= 86400*5) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel6;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else if (timeIntervalDiff > 86400*5 && timeIntervalDiff <= 86400*6) {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
        }
        _highlightLabel = _dateLabel7;
        _highlightLabel.layer.borderColor = [SPGlobalConfig themeColor].CGColor;
        _highlightLabel.textColor = [SPGlobalConfig themeColor];
    } else {
        if (_highlightLabel) {
            _highlightLabel.layer.borderColor = [UIColor blackColor].CGColor;
            _highlightLabel.textColor = [UIColor blackColor];
            _highlightLabel = nil;
        }
    }
}

@end
