//
//  SPPersonalInfoTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalInfoTableViewCell.h"

@interface SPPersonalInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

@end

@implementation SPPersonalInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithTitle:(NSString *)title content:(NSString *)content imageName:(NSString *)imageName {
    _titleLabel.text = title;
    _contentLabel.text = content;
    _cellImageView.image = [UIImage imageNamed:imageName];
}

@end
