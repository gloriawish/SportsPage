//
//  SPPersonaClubInfoSettingTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/3/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPPersonalClubInfoSettingTableViewCellSyle) {
    SPPersonalClubInfoSettingTableViewCellSyleTeamImage = 1,
    SPPersonalClubInfoSettingTableViewCellSyleClubName  = 2,
    SPPersonalClubInfoSettingTableViewCellSyleClubEvent = 3
};

@interface SPPersonaClubInfoSettingTableViewCell : UITableViewCell

- (void)setUpCellStyle:(SPPersonalClubInfoSettingTableViewCellSyle)style;

- (void)setUpCellImage:(UIImage *)image;
//- (void)setUpCellImageName:(NSString *)imageName;
- (void)setUpCellContent:(NSString *)content;

@end
