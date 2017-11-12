//
//  SPPersonalClubSettingTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPPersonalClubSettingTableViewCellSyle) {
    SPPersonalClubSettingTableViewCellSyleJoinClubWay = 1,
    SPPersonalClubSettingTableViewCellSyleInfo        = 2,
    SPPersonalClubSettingTableViewCellSyleShare       = 3
};

@interface SPPersonalClubSettingTableViewCell : UITableViewCell

/*
 SPPersonalClubSettingTableViewCellSyleManage
 SPPersonalClubSettingTableViewCellSyleInfo
 SPPersonalClubSettingTableViewCellSyleShare
 */
- (void)setUpStyle:(SPPersonalClubSettingTableViewCellSyle)style;

@end
