//
//  SPAddFrendsCell.m
//  SportsPage
//
//  Created by absolute on 2016/10/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPAddFrendsCell.h"

@interface SPAddFrendsCell ()


@property (weak, nonatomic) IBOutlet UIImageView *sysImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SPAddFrendsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _sysImageView.layer.cornerRadius = 4;
    _sysImageView.layer.masksToBounds = true;
}

- (void)setUpCellWithContent:(NSString *)content time:(long long)time {
    if (content.length != 0) {
        _contentLabel.text = content;
    } else {
        _contentLabel.text = @"";
    }
    _timeLabel.text = [self timeIntervalToString:time/1000];
}

- (NSString *)timeIntervalToString:(long long)timeInterval {
    long timeIntervalDiff = (long)[[NSDate date] timeIntervalSince1970] - timeInterval;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timeIntervalDiff < 86400) {
        [formatter setDateFormat:@"HH:mm"];
        NSString *tempTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
        int hourNum = [[tempTime substringToIndex:2] intValue];
        int minNum = [[tempTime substringFromIndex:3] intValue];
        if (hourNum > 12) {
            return [NSString stringWithFormat:@"下午 %d:%d",hourNum-12,minNum];
        } else if (hourNum == 12) {
            return [NSString stringWithFormat:@"中午 %d:%d",hourNum,minNum];
        } else if (hourNum < 12) {
            return [NSString stringWithFormat:@"上午 %d:%d",hourNum,minNum];
        }
    } else if (timeIntervalDiff>=86400 && timeIntervalDiff<172800) {
        return @"昨天";
    } else if (timeIntervalDiff>=172800 && timeIntervalDiff<(86400*9)) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setFirstWeekday:2];
        NSUInteger ret = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
        switch (ret) {
            case 1:
                return @"星期一";
                break;
            case 2:
                return @"星期二";
                break;
            case 3:
                return @"星期三";
                break;
            case 4:
                return @"星期四";
                break;
            case 5:
                return @"星期五";
                break;
            case 6:
                return @"星期六";
                break;
            case 7:
                return @"星期天";
                break;
            default:
                break;
        }
    } else {
        [formatter setDateFormat:@"MM-dd"];
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return nil;
}


@end
