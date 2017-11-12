//
//  SPPersonalMessageNotificationTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/7.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalMessageNotificationTableViewCell.h"

#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"

#import <AudioToolbox/AudioToolbox.h>

@interface SPPersonalMessageNotificationTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectSwitch;

@end

@implementation SPPersonalMessageNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_selectSwitch setOnTintColor:[SPGlobalConfig themeColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)switchAction:(UISwitch *)sender {
    if ([_contentLabel.text isEqualToString:@"接受消息通知"]) {
        [RCIM sharedRCIM].disableMessageNotificaiton = !sender.isOn;
    } else if ([_contentLabel.text isEqualToString:@"显示消息详情"]) {
#warning 显示消息详情 TODO
        NSLog(@"显示消息详情");
    } else if ([_contentLabel.text isEqualToString:@"声音"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:sender.isOn?2:1 forKey:@"playSound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [RCIM sharedRCIM].disableMessageAlertSound = !sender.isOn;
    } else if ([_contentLabel.text isEqualToString:@"震动"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:sender.isOn?2:1 forKey:@"playAlert"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)setUpWithContent:(NSString *)content isOn:(BOOL)isOn {
    
    if ([content isEqualToString:@"声音"]) {
        _selectSwitch.on = ![RCIM sharedRCIM].disableMessageAlertSound;
    } else if ([content isEqualToString:@"震动"]) {
        NSInteger playAlert = [[NSUserDefaults standardUserDefaults] integerForKey:@"playAlert"];
        if (playAlert == 0 || playAlert == 2) {
            _selectSwitch.on = true;
        } else {
            _selectSwitch.on = false;
        }
    } else if ([content isEqualToString:@"接受消息通知"]) {
        _selectSwitch.on = ![RCIM sharedRCIM].disableMessageNotificaiton;
    } else {
        _selectSwitch.on = isOn;
    }
    _contentLabel.text = content;
}

@end
