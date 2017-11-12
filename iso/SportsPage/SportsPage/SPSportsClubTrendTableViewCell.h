//
//  SPSportsClubTrendTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/2/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPClubDetailActiveModel;

@interface SPSportsClubTrendTableViewCell : UITableViewCell

- (void)setTopLineViewHidden:(BOOL)isHidden;
- (void)setBottomLineViewHidden:(BOOL)isHidden;
//- (void)setContent:(NSString *)content;

- (void)setActivesModel:(SPClubDetailActiveModel *)model headerImageUrl:(NSString *)imageUrl;

@end
