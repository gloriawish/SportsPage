//
//  SPSportsOrderTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/25.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsOrderTableViewCell.h"

@interface SPSportsOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation SPSportsOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithImageName:(NSString *)imageName title:(NSString *)title content:(NSString *)content lineViewHidden:(BOOL)isHidden {
    _headImageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
    _contentLabel.text = content;
    if (isHidden) {
        _lineView.hidden = true;
    }
}

@end
