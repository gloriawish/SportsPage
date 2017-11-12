//
//  SPMemberBorderView.m
//  SportsPage
//
//  Created by Qin on 2016/11/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPMemberBorderView.h"

@interface SPMemberBorderView () <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSMutableArray *_minDataArray;
    NSMutableArray *_maxDataArray;
}

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation SPMemberBorderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = true;
    [_confirmButton setBackgroundColor:[SPGlobalConfig themeColor]];
    
    [self fillData];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [_pickerView selectRow:4 inComponent:0 animated:false];
    [_pickerView selectRow:8 inComponent:1 animated:false];
}

- (void)fillData {
    _minDataArray = [[NSMutableArray alloc] init];
    _maxDataArray = [[NSMutableArray alloc] init];
    
    for (int i=1; i<200; i++) {
        [_minDataArray addObject:[NSString stringWithFormat:@"%d人",i]];
        [_maxDataArray addObject:[NSString stringWithFormat:@"%d人",i+1]];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint clickPoint = [touch locationInView:_memberPickerView];
    
    if (!CGRectContainsPoint(_memberPickerView.bounds, clickPoint)) {
        [UIView animateWithDuration:0.5 animations:^{
            _memberPickerView.alpha = 0;
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
    NSString *minString =  _minDataArray[[_pickerView selectedRowInComponent:0]];
    NSString *maxString =  _maxDataArray[[_pickerView selectedRowInComponent:1]];
    
    NSString *string = [NSString stringWithFormat:@"%@ ~ %@",minString,maxString];
    
    [_createNextStepViewController.imageArray replaceObjectAtIndex:3 withObject:@"Sports_create_step2_person_blue"];
    if (!string) {
        [_createNextStepViewController.dataStringArray replaceObjectAtIndex:2 withObject:@""];
    } else {
        [_createNextStepViewController.dataStringArray replaceObjectAtIndex:2 withObject:string];
    }
    [_createNextStepViewController.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [UIView animateWithDuration:0.5 animations:^{
        _memberPickerView.alpha = 0;
        _createNextStepViewController.windowImageView.alpha = 0;
        self.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [_createNextStepViewController.windowImageView removeFromSuperview];
        _createNextStepViewController.isSubWindowDisplay = false;
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 199;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _minDataArray[row];
    } else {
        return _maxDataArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSInteger component2Row = [pickerView selectedRowInComponent:1];
        if (row > component2Row) {
            [pickerView selectRow:row inComponent:1 animated:true];
        }
    } else {
        NSInteger component1Row = [pickerView selectedRowInComponent:0];
        if (row < component1Row) {
            [pickerView selectRow:row inComponent:0 animated:true];
        }
    }
}

@end
