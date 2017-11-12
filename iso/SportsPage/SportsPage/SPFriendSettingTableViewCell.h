//
//  SPFriendSettingTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/10/29.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RongCloud/RongIMKit.framework/Headers/RongIMKit.h"

@interface SPFriendSettingTableViewCell : UITableViewCell

- (void)setCellWithTitle:(NSString *)title hiddenMoreImage:(BOOL)isHiddenMoreImage hiddenSwitch:(BOOL)isHiddenSwitch;

- (void)setCellWithTitle:(NSString *)title
         hiddenMoreImage:(BOOL)isHiddenMoreImage
            hiddenSwitch:(BOOL)isHiddenSwitch
        conversationType:(RCConversationType)conversationType
                targetId:(NSString *)targetId;

@end
