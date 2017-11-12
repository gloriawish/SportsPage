//
//  SPPersonalAccountDefiniteTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalAccountDefiniteTableViewCell.h"

@interface SPPersonalAccountDefiniteTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation SPPersonalAccountDefiniteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp {
    _timeLabel.textColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
}

- (void)setUpWithType:(NSString *)type balance:(NSString *)balance time:(NSString *)time money:(NSString *)money remark:(NSString *)remark {
    if (balance.length != 0) {
        _balanceLabel.text = [NSString stringWithFormat:@"余额: %@",balance];
    } else {
        _balanceLabel.text = @"";
    }
    [_balanceLabel sizeToFit];
    
    if (time.length != 0) {
        _timeLabel.text = [time substringWithRange:NSMakeRange(0, 10)];
    } else {
        _timeLabel.text = @"";
    }
    [_timeLabel sizeToFit];
    
    if ([type isEqualToString:@"1"]) {
        _moneyLabel.textColor = [SPGlobalConfig anyColorWithRed:40 green:170 blue:0 alpha:1];
        _moneyLabel.text = [NSString stringWithFormat:@"+%@",money];
    } else if ([type isEqualToString:@"2"]) {
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.text = [NSString stringWithFormat:@"-%@",money];
    }
    [_moneyLabel sizeToFit];
    
    if (remark.length != 0) {
        _typeLabel.text = remark;
    } else {
        _typeLabel.text = @"";
    }
    [_typeLabel sizeToFit];
    
}

@end
