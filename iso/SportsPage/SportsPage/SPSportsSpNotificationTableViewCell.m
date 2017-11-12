//
//  SPSportsSpNotificationTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/11.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSpNotificationTableViewCell.h"

@interface SPSportsSpNotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (weak, nonatomic) IBOutlet UILabel *sportNotificationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkDetailLabel;

@end

@implementation SPSportsSpNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _checkDetailLabel.textColor = [SPGlobalConfig themeColor];
    
    _dataView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    _dataView.layer.shadowOpacity = 0.5;
    _dataView.layer.shadowOffset = CGSizeMake(2, 2);

    self.contentView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithModel:(SPSportsNotificationModel *)model {
    
    //运动消息类型&图片
    if ([model.type isEqualToString:@"2001"]) {
        _sportNotificationTypeLabel.text = @"已关注运动页激活";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_active"];
    } else if ([model.type isEqualToString:@"2002"]) {
        _sportNotificationTypeLabel.text = @"运动即将开始";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_eventBegin"];
    } else if ([model.type isEqualToString:@"2004"]) {
        _sportNotificationTypeLabel.text = @"报名成功";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_signUp"];
    } else {
        _sportNotificationTypeLabel.text = @"系统消息";
        _contentImageView.image = [UIImage imageNamed:@"Sports_notification_system"];
    }
    
    //时间
    if (model.time.length != 0) {
        _timeLabel.text = [model.time substringWithRange:NSMakeRange(0, 10)];
    } else {
        _timeLabel.text = @"";
    }
    
    //通知内容
    if (model.content.length != 0) {
        _contentLabel.text = model.content;
    } else {
        _contentLabel.text = @"";
    }
    
}

@end
