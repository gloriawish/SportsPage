//
//  SPClubInviewListTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/4/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPClubInviteListModel;
@class SPClubApplyListModel;

@interface SPClubInviewListTableViewCell : UITableViewCell

@property (weak) id delegate;

- (void)setUpClubModel:(SPClubInviteListModel *)model;
- (void)setUpApplyModel:(SPClubApplyListModel *)model;

@end
