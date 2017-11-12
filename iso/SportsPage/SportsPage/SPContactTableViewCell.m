//
//  SPContactTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/10/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPContactTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SPContactTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation SPContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithImageName:(NSString *)imageName content:(NSString *)content {
    self.headImageView.image = [UIImage imageNamed:imageName];
    self.userNameLabel.text = content;
}

- (void)setupWithModel:(SPUserInfoModel *)model {
    if (model.portrait.length != 0) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
    } else {
        self.headImageView.image = [UIImage imageNamed:@"IM_placeholder"];
    }
    if (model.nick != 0) {
        self.userNameLabel.text = model.nick;
    }
}

- (void)setUpWithGroupImageName:(NSString *)imageName title:(NSString *)title {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
    _userNameLabel.text = title;
}

@end
