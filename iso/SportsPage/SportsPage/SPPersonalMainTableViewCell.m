//
//  SPPersonalMainTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalMainTableViewCell.h"

@interface SPPersonalMainTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *MoreImageView;

@end

@implementation SPPersonalMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithImageName:(NSString *)imageName title:(NSString *)title {
    _headerImageView.image = [UIImage imageNamed:imageName];
    _titleLabel.text = title;
}

- (void)setUpWithContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setUpLineHidden:(BOOL)isHidden {
    _lineView.hidden = isHidden;
}

- (void)setUpMoreImageHidden:(BOOL)isHidden {
    _MoreImageView.hidden = isHidden;
}

- (void)setUpMoreImage:(NSString *)imageName {
    _MoreImageView.image = [UIImage imageNamed:imageName];
}

@end
