//
//  SPPersonalSportsPageUnbindTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalSportsPageUnbindTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalSportsPageUnbindTableViewCell () {
    CALayer *_shadowlayer;
    BOOL _isSelectedImage;
}

@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *activeTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@end

@implementation SPPersonalSportsPageUnbindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - SetUp
- (void)setUp {
    _isSelectedImage = false;
    
    self.contentView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = true;
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.backgroundColor = [UIColor redColor];
    
    _dataView.layer.cornerRadius = 5;
    _dataView.layer.masksToBounds = true;
    
    _shadowlayer = [CALayer layer];
    if (SCREEN_WIDTH == 320) {
        _shadowlayer.frame = CGRectMake(30, 5, 280, 120);
    } else if (SCREEN_WIDTH == 375) {
        _shadowlayer.frame = CGRectMake(30, 5, 335, 120);
    } else {
        _shadowlayer.frame = CGRectMake(30, 5, 374, 120);
    }
    _shadowlayer.cornerRadius = 5;
    _shadowlayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _shadowlayer.masksToBounds = false;
    _shadowlayer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    _shadowlayer.shadowOffset = CGSizeMake(2, 2);
    _shadowlayer.shadowOpacity = 1;
    _shadowlayer.shouldRasterize = true;
    [self.contentView.layer insertSublayer:_shadowlayer below:_dataView.layer];

}

- (void)setUpWithModel:(SPSportsPageModel *)model {
    //运动名称
    if (model.title.length != 0) {
        _titleLabel.text = model.title;
    } else {
        _titleLabel.text = @"名称待定";
    }
    
    //运动页状态
    if ([model.status isEqualToString:@"0"]) {
        _statusImageView.image = [UIImage imageNamed:@"Mine_sportsPage_unActive"];
    } else if ([model.status isEqualToString:@"1"]) {
        _statusImageView.image = [UIImage imageNamed:@"Mine_sportsPage_active"];
    }
    
    //运动图片
    if (model.portrait.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    //运动评分图片
    if (model.grade.length != 0) {
        _starImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Sports_star_%@",model.grade]];
    } else {
        _starImageView.image = [UIImage imageNamed:@"Sports_star_3.5"];
    }
    
    //激活次数
    if (model.active_times.length != 0) {
        if ([model.active_times isEqualToString:@"0"]) {
            _activeTimesLabel.text = @"(从未激活)";
        } else {
            _activeTimesLabel.text = [NSString stringWithFormat:@"(已激活%@次)",model.active_times];
        }
    } else {
        _activeTimesLabel.text = @"";
    }
    
    //运动项目
    if ([model.sport_item isEqualToString:@"1"]) {
        _eventLabel.text = @"羽毛球";
    } else if ([model.sport_item isEqualToString:@"2"]) {
        _eventLabel.text = @"足球";
    } else if ([model.sport_item isEqualToString:@"3"]) {
        _eventLabel.text = @"篮球";
    } else if ([model.sport_item isEqualToString:@"4"]) {
        _eventLabel.text = @"网球";
    } else if ([model.sport_item isEqualToString:@"5"]) {
        _eventLabel.text = @"跑步";
    } else if ([model.sport_item isEqualToString:@"6"]) {
        _eventLabel.text = @"游泳";
    } else if ([model.sport_item isEqualToString:@"7"]) {
        _eventLabel.text = @"壁球";
    } else if ([model.sport_item isEqualToString:@"8"]) {
        _eventLabel.text = @"皮划艇";
    } else if ([model.sport_item isEqualToString:@"9"]) {
        _eventLabel.text = @"棒球";
    } else if ([model.sport_item isEqualToString:@"10"]) {
        _eventLabel.text = @"乒乓";
    } else {
        _eventLabel.text = model.extend;
    }
    
    //运动地址
    if (model.location.length != 0) {
        _locationLabel.text = model.location;
    } else {
        _locationLabel.text = @"";
    }
    
}

- (void)changeSelectedImageStatus {
    if (_isSelectedImage) {
        _selectedImageView.image = [UIImage imageNamed:@"club_unbind_normal"];
    } else {
        _selectedImageView.image = [UIImage imageNamed:@"club_unbind_selected"];
    }
    _isSelectedImage = !_isSelectedImage;
}

- (BOOL)isSelectedImage {
    return _isSelectedImage;
}

@end
