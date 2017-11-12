//
//  SPSportsClubTrendTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/2/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubTrendTableViewCell.h"

#import "SPClubDetailResponseModel.h"

#import "UIImageView+WebCache.h"

@interface SPSportsClubTrendTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UIView *backgroundLabelView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation SPSportsClubTrendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _topLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:201 green:201 blue:201 alpha:1];
    _bottomLineView.backgroundColor = [SPGlobalConfig anyColorWithRed:201 green:201 blue:201 alpha:1];
    
    _backgroundLabelView.layer.cornerRadius = 5;
    _backgroundLabelView.layer.masksToBounds = true;
    _backgroundLabelView.backgroundColor = [SPGlobalConfig anyColorWithRed:229 green:229 blue:229 alpha:1];
}

- (void)setTopLineViewHidden:(BOOL)isHidden {
    _topLineView.hidden = isHidden;
}

- (void)setBottomLineViewHidden:(BOOL)isHidden {
    _bottomLineView.hidden = isHidden;
}

- (void)setContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setActivesModel:(SPClubDetailActiveModel *)model headerImageUrl:(NSString *)imageUrl {
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
    _contentLabel.text = model.desc;
    
    if (model.time.length == 0) {
        _timeLabel.hidden = true;
        _dateLabel.hidden = true;
    } else {
        _dateLabel.text = [model.time substringWithRange:NSMakeRange(5, 5)];
        _timeLabel.text = [model.time substringWithRange:NSMakeRange(11, 5)];
    }
}

@end
