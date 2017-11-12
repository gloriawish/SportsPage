//
//  SPSportsSysNotificationTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSysNotificationTableViewCell.h"

@interface SPSportsSysNotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (weak, nonatomic) IBOutlet UILabel *systemNotificationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SPSportsSysNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dataView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    _dataView.layer.shadowOpacity = 0.5;
    _dataView.layer.shadowOffset = CGSizeMake(2, 2);
    self.contentView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithModel:(SPSportsNotificationModel *)model {
    
    //系统消息类型&图片
    if ([model.type isEqualToString:@"1001"]) {
        _systemNotificationTypeLabel.text = @"系统消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_system"];
    } else if ([model.type isEqualToString:@"1002"]) {
        _systemNotificationTypeLabel.text = @"充值消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_charge"];
    } else if ([model.type isEqualToString:@"1003"]) {
        _systemNotificationTypeLabel.text = @"提现消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_drawWith"];
    } else if ([model.type isEqualToString:@"1004"]) {
        _systemNotificationTypeLabel.text = @"结算消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_settle"];
    } else if ([model.type isEqualToString:@"2003"]) {
        _systemNotificationTypeLabel.text = @"运动解散";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_eventDismiss"];
    } else if ([model.type isEqualToString:@"2005"]) {
        _systemNotificationTypeLabel.text = @"取消报名成功";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_dismissSignUp"];
    } else if ([model.type isEqualToString:@"2006"]) {
        _systemNotificationTypeLabel.text = @"运动群即将解散";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_groupDismiss"];
    } else {
        _systemNotificationTypeLabel.text = @"系统消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_system"];
    }
    
    //时间
    if (model.time.length != 0) {
        _timeLabel.text = [model.time substringWithRange:NSMakeRange(0, 10)];
    } else {
        _timeLabel.text = @"时间待定";
    }
    
    //通知内容
    if (model.content.length != 0) {
        _contentLabel.text = model.content;
    } else {
        _contentLabel.text = @"通知内容为空";
    }
    
}

@end
