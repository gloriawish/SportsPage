//
//  SPPersonalClubTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/10.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubTableViewCell.h"

#import "SPClubListResponseModel.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalClubTableViewCell () {
    SPClubListModel *_clubListModel;
}

@property (weak, nonatomic) IBOutlet UIView *clubBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *clubImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *clubEventImageView;

@property (weak, nonatomic) IBOutlet UILabel *clubDynamicLabel;
@property (weak, nonatomic) IBOutlet UILabel *clubDynamicValueLabel;

@property (weak, nonatomic) IBOutlet UIView *clubDynamicBackView;
@property (weak, nonatomic) IBOutlet UIView *clubDynamicFrontView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clubDynamicConstraint;

@property (weak, nonatomic) IBOutlet UIButton *clubMembersButton;
@property (weak, nonatomic) IBOutlet UIButton *clubSportsPageButton;

@property (weak, nonatomic) IBOutlet UIView *clubLineView;

@end

@implementation SPPersonalClubTableViewCell

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

    UIColor *viewGrayColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    UIColor *textGrayColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
    self.backgroundColor = viewGrayColor;
    
    _clubNameLabel.textColor = textGrayColor;
    
    _clubDynamicBackView.backgroundColor = viewGrayColor;
    _clubDynamicFrontView.backgroundColor = [SPGlobalConfig themeColor];
    
    _clubDynamicLabel.textColor = textGrayColor;
    _clubDynamicValueLabel.textColor = [SPGlobalConfig themeColor];
    
    [_clubMembersButton setTitleColor:textGrayColor forState:UIControlStateNormal];
    [_clubSportsPageButton setTitleColor:textGrayColor forState:UIControlStateNormal];
    
    _clubLineView.backgroundColor = viewGrayColor;
    
    [self setUpCircleRound];
}

- (void)setUpCircleRound {
    _clubBackgroundView.layer.cornerRadius = 5;
    _clubBackgroundView.layer.masksToBounds = true;
    
    _clubDynamicFrontView.layer.cornerRadius = 6;
    _clubDynamicFrontView.layer.masksToBounds = true;
    _clubDynamicBackView.layer.cornerRadius = 6;
    _clubDynamicBackView.layer.masksToBounds = true;
}

- (void)setUpClubListModel:(SPClubListModel *)model {
    
    _clubListModel = model;
    
    //队徽
    [_clubImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    
    //项目
    NSString *imageName = nil;
    if ([model.sport_item isEqualToString:@"1"]) {
        imageName = @"Sports_event_badminton";
    } else if ([model.sport_item isEqualToString:@"2"]) {
        imageName = @"Sports_event_football";
    } else if ([model.sport_item isEqualToString:@"3"]) {
        imageName = @"Sports_event_basketball";
    } else if ([model.sport_item isEqualToString:@"4"]) {
        imageName = @"Sports_event_tennis";
    } else if ([model.sport_item isEqualToString:@"5"]) {
        imageName = @"Sports_event_jogging";
    } else if ([model.sport_item isEqualToString:@"6"]) {
        imageName = @"Sports_event_swimming";
    } else if ([model.sport_item isEqualToString:@"7"]) {
        imageName = @"Sports_event_squash";
    } else if ([model.sport_item isEqualToString:@"8"]) {
        imageName = @"Sports_event_kayak";
    } else if ([model.sport_item isEqualToString:@"9"]) {
        imageName = @"Sports_event_baseball";
    } else if ([model.sport_item isEqualToString:@"10"]) {
        imageName = @"Sports_event_pingpang";
    } else {
        imageName = @"Sports_event_custom";
    }
    _clubEventImageView.image = [UIImage imageNamed:imageName];
    
    //俱乐部名
    _clubNameLabel.text = model.name;
    
    //活跃度
    _clubDynamicValueLabel.text = [NSString stringWithFormat:@"%@/%@",model.vitality,model.max_vitality];
    
    if ([model.vitality isEqualToString:@"0"]) {
        _clubDynamicConstraint.constant = _clubDynamicBackView.frame.size.width;
    } else if ([model.vitality integerValue] >= [model.max_vitality integerValue]) {
        _clubDynamicConstraint.constant = 0;
    } else {
        CGFloat width = _clubDynamicBackView.frame.size.width;
        _clubDynamicConstraint.constant = width - [model.vitality integerValue] * width / [model.max_vitality integerValue];
    }
    
    //button
    [_clubMembersButton setTitle:model.member_count forState:UIControlStateNormal];
    [_clubSportsPageButton setTitle:model.sport_count forState:UIControlStateNormal];

}

@end
