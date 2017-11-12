//
//  SPUserInfoTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/10/21.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPUserInfoTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SPUserInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatLabel;

@end

@implementation SPUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _weChatLabel.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupWithUserInfoModel:(SPUserInfoModel *)model {
    
    if (model.remark.length != 0) {
        _userNameLabel.text = model.remark;
    } else {
        _userNameLabel.text = model.nick;
    }
    
    if (model.mobile.length != 0) {
        _mobileLabel.text = [NSString stringWithFormat:@"手机号: %@",model.mobile];
    } else {
        _mobileLabel.text = @"手机号: 未绑定";
    }
    
    _headImageView.layer.cornerRadius = 8;
    _headImageView.layer.masksToBounds = true;
    if (model.portrait.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"IM_placeholder"];
    }
}

@end
