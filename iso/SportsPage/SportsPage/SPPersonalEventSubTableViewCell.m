//
//  SPPersonalEventSubTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalEventSubTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalEventSubTableViewCell () {
    SPPersonalEventModel *_model;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *changeImageView;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sportsTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIView *dataContentView;

@end

@implementation SPPersonalEventSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp {
    self.contentView.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:244 alpha:1];
    
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.clipsToBounds = true;
    
    _initiateLabel.textColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
    _sportsTypeLabel.textColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
    _changeLabel.textColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
    _priceLabel.textColor = [SPGlobalConfig anyColorWithRed:172 green:172 blue:172 alpha:1];
    
    _dataContentView.layer.cornerRadius = 10;
    _dataContentView.layer.masksToBounds = true;
    
    CALayer *shadowlayer = [CALayer layer];
    if (SCREEN_WIDTH == 320) {
        shadowlayer.frame = CGRectMake(10, 10, 300, 135);
    } else if (SCREEN_WIDTH == 375) {
        shadowlayer.frame = CGRectMake(10, 10, 355, 161.640625);
    } else {
        shadowlayer.frame = CGRectMake(10, 10, 394, 180.53125);
    }
    shadowlayer.cornerRadius = 10;
    shadowlayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    shadowlayer.masksToBounds = false;
    shadowlayer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    shadowlayer.shadowOffset = CGSizeMake(2, 2);
    shadowlayer.shadowOpacity = 1;
    shadowlayer.shouldRasterize = true;
    [self.contentView.layer insertSublayer:shadowlayer below:_dataContentView.layer];
}

- (void)setUpWithModel:(SPPersonalEventModel *)model {
    _model = model;
    
    if (model.title.length != 0) {
        _titleLabel.text = model.title;
    } else {
        _titleLabel.text = @"运动名称待定";
    }
    [_titleLabel sizeToFit];
    
    if (model.status.length != 0) {
        _statusLabel.text = model.status;
    } else {
        _statusLabel.text = @"无状态";
    }
    _statusLabel.textAlignment = NSTextAlignmentRight;
    
    if (model.portrait.length != 0) {
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]
                             placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _contentImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    if (model.location.length != 0) {
        _locationLabel.text = model.location;
    } else {
        _locationLabel.text = @"地址待定";
    }
    //[_locationLabel sizeToFit];
    
    if (model.start_time.length >= 16) {
        _timeLabel.text = [model.start_time substringWithRange:NSMakeRange(0, 16)];
    } else {
        _timeLabel.text = @"时间待定";
    }
    //[_timeLabel sizeToFit];
    
    if (model.creator.length != 0) {
        _initiateLabel.text = model.creator;
    } else {
        _initiateLabel.text = @"还没发起人";
    }
    [_initiateLabel sizeToFit];
    
    if ([model.sport_item isEqualToString:@"1"]) {
        _sportsTypeLabel.text = @"羽毛球";
    } else if ([model.sport_item isEqualToString:@"2"]) {
        _sportsTypeLabel.text = @"足球";
    } else if ([model.sport_item isEqualToString:@"3"]) {
        _sportsTypeLabel.text = @"篮球";
    } else if ([model.sport_item isEqualToString:@"4"]) {
        _sportsTypeLabel.text = @"网球";
    } else if ([model.sport_item isEqualToString:@"5"]) {
        _sportsTypeLabel.text = @"跑步";
    } else if ([model.sport_item isEqualToString:@"6"]) {
        _sportsTypeLabel.text = @"游泳";
    } else if ([model.sport_item isEqualToString:@"7"]) {
        _sportsTypeLabel.text = @"壁球";
    } else if ([model.sport_item isEqualToString:@"8"]) {
        _sportsTypeLabel.text = @"皮划艇";
    } else if ([model.sport_item isEqualToString:@"9"]) {
        _sportsTypeLabel.text = @"棒球";
    } else if ([model.sport_item isEqualToString:@"10"]) {
        _sportsTypeLabel.text = @"乒乓";
    } else {
        _sportsTypeLabel.text = @"自定义";
        
    }
    [_sportsTypeLabel sizeToFit];
    
    NSString *chargeTypeStr = @"线上";
    if ([model.charge_type isEqualToString:@"2"]) {
        chargeTypeStr = @"线下";
    }
    
    if ([model.status isEqualToString:@"进行中"]) {
        NSString *tempStr = [NSString stringWithFormat:@"%@/%@",model.enroll_number,model.max_number];
        _changeLabel.text = tempStr;
        _changeImageView.image = [UIImage imageNamed:@"Mine_main_members"];
    } else if ([model.status isEqualToString:@"待结算"]) {
        _changeLabel.text = chargeTypeStr;
    } else if ([model.status isEqualToString:@"待评价"]) {
        _changeLabel.text = chargeTypeStr;
    } else {
        _changeLabel.text = chargeTypeStr;
    }
    [_changeImageView sizeToFit];
    
    if (model.price.length != 0) {
        _priceLabel.text = model.price;
    } else {
        _priceLabel.text = @"金额待定";
    }
    [_priceLabel sizeToFit];
    
}

@end
