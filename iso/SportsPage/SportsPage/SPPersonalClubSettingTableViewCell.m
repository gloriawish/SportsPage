//
//  SPPersonalClubSettingTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubSettingTableViewCell.h"

@interface SPPersonalClubSettingTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SPPersonalClubSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - SetUp
- (void)setUp {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setUpStyle:(SPPersonalClubSettingTableViewCellSyle)style {
    if (style == SPPersonalClubSettingTableViewCellSyleInfo) {
        _titleLabel.text = @"俱乐部资料";
    } else if (style == SPPersonalClubSettingTableViewCellSyleJoinClubWay) {
        _titleLabel.text = @"俱乐部加入方式";
    } else if (style == SPPersonalClubSettingTableViewCellSyleShare) {
        _titleLabel.text = @"分享俱乐部";
        _lineView.hidden = true;
    }
}

@end
