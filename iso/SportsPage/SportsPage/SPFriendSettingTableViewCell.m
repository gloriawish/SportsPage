//
//  SPFriendSettingTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/10/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPFriendSettingTableViewCell.h"

@interface SPFriendSettingTableViewCell () {
    RCConversationType _conversationType;
    NSString *_targetId;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;

@end

@implementation SPFriendSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_cellSwitch setOnTintColor:[SPGlobalConfig themeColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellWithTitle:(NSString *)title hiddenMoreImage:(BOOL)isHiddenMoreImage hiddenSwitch:(BOOL)isHiddenSwitch {
    _titleLabel.text = title;
    if (isHiddenMoreImage) {
        _moreImageView.hidden = true;
    }
    if (isHiddenSwitch) {
        _cellSwitch.hidden = true;
    }
}

- (void)setCellWithTitle:(NSString *)title
         hiddenMoreImage:(BOOL)isHiddenMoreImage
            hiddenSwitch:(BOOL)isHiddenSwitch
        conversationType:(RCConversationType)conversationType
                targetId:(NSString *)targetId {
    _titleLabel.text = title;
    if (isHiddenMoreImage) {
        _moreImageView.hidden = true;
    }
    if (isHiddenSwitch) {
        _cellSwitch.hidden = true;
    }
    
    _conversationType = conversationType;
    _targetId = targetId;
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:conversationType targetId:targetId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus == DO_NOT_DISTURB) {
            _cellSwitch.on = true;
        } else if (nStatus == NOTIFY) {
            _cellSwitch.on = false;
        }
    } error:^(RCErrorCode status) {
        _cellSwitch.on = false;
    }];
}

- (IBAction)switchChangeAction:(UISwitch *)sender {
    if ([_titleLabel.text isEqualToString:@"消息免打扰"]) {
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:_conversationType targetId:_targetId isBlocked:sender.isOn success:^(RCConversationNotificationStatus nStatus) {
            if (nStatus == DO_NOT_DISTURB) {
                NSLog(@"设置消息免打扰成功");
            } else if (nStatus == NOTIFY) {
                NSLog(@"取消消息免打扰成功");
            }
        } error:^(RCErrorCode status) {
            _cellSwitch.on = !_cellSwitch.on;
            [SPGlobalConfig showTextOfHUD:@"设置免打扰失败" ToView:self];
        }];
    }
}

@end
