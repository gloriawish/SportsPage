//
//  SPCreateEventTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPCreateEventTableViewCell.h"

@implementation SPCreateEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lineView.backgroundColor = [SPGlobalConfig anyColorWithRed:220 green:220 blue:220 alpha:1];
    
//    _selectedTextLabel1.hidden = true;
//    _selectedTextLabel2.hidden = true;
//    _selectedTextLabel3.hidden = true;
//    _selectedTextImageView1.hidden = true;
//    _selectedTextImageView2.hidden = true;
//    _selectedTextImageView3.hidden = true;
//    _privacySwitch.hidden = true;
    
    [self setUpGestureWithView:_selectedTextImageView1 selector:@selector(tapAction:)];
    [self setUpGestureWithView:_selectedTextLabel1 selector:@selector(tapAction:)];
    [self setUpGestureWithView:_selectedTextImageView2 selector:@selector(tapAction:)];
    [self setUpGestureWithView:_selectedTextLabel2 selector:@selector(tapAction:)];
    [self setUpGestureWithView:_selectedTextImageView3 selector:@selector(tapAction:)];
    [self setUpGestureWithView:_selectedTextLabel3 selector:@selector(tapAction:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpGestureWithView:(UIView *)sender selector:(SEL)selector {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [sender addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (sender.view == _selectedTextLabel1 || sender.view == _selectedTextImageView1) {
        _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
        _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _contentLabel.text = _selectedTextLabel1.text;
    } else if (sender.view == _selectedTextLabel2 || sender.view == _selectedTextImageView2) {
        _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
        _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _contentLabel.text = _selectedTextLabel2.text;
    } else if (sender.view == _selectedTextLabel3 || sender.view == _selectedTextImageView3) {
        _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
        _contentLabel.text = _selectedTextLabel3.text;
    }
    
    if ([_contentLabel.text isEqualToString:@"简单"]
        || [_contentLabel.text isEqualToString:@"一般"]
        || [_contentLabel.text isEqualToString:@"困难"]) {
        _headerImageView.image = [UIImage imageNamed:@"Sports_create_step2_lv_blue"];
    } else {
        _headerImageView.image = [UIImage imageNamed:@"Sports_create_step2_charge_blue"];
    }

}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        _contentLabel.text = @"是";
    } else {
        _contentLabel.text = @"否";
    }
}

- (void)setUpCellWithSelectedViewHidden1:(BOOL)isHidden1
                     selectedViewHidden2:(BOOL)isHidden2
                     selectedViewHidden3:(BOOL)isHidden3
                            switchHidden:(BOOL)isSwitchHidden
                      contentLabelHidden:(BOOL)isContentLabelHidden {
    _selectedTextLabel1.hidden = isHidden1;
    _selectedTextImageView1.hidden = isHidden1;
    
    _selectedTextLabel2.hidden = isHidden2;
    _selectedTextImageView2.hidden = isHidden2;
    
    _selectedTextLabel3.hidden = isHidden3;
    _selectedTextImageView3.hidden = isHidden3;
    
    _privacySwitch.hidden = isSwitchHidden;
    
    _contentLabel.hidden = isContentLabelHidden;
}

- (void)setUpCellWithContent1:(NSString *)content1
                     content2:(NSString *)content2
                     content3:(NSString *)content3 {
    _selectedTextLabel1.text = content1;
    _selectedTextLabel2.text = content2;
    _selectedTextLabel3.text = content3;
}

- (void)setUpCellImageView:(NSString *)imageName title:(NSString *)title {
    _titleLabel.text = title;
    _headerImageView.image = [UIImage imageNamed:imageName];
}

- (void)setUpCellContent:(NSString *)content {
    _contentLabel.text = content;
}

- (void)setUpWithFillUpData:(NSString *)title model:(SPLastEventModel *)model {
    if ([title isEqualToString:@"运动等级"]) {
        
        if ([model.level isEqualToString:@"1"]) {
            _contentLabel.text = @"简单";
            _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
            _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
            _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
        } else if ([model.level isEqualToString:@"2"]) {
            _contentLabel.text = @"一般";
            _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
            _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
            _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        } else if ([model.level isEqualToString:@"3"]) {
            _contentLabel.text = @"困难";
            _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
            _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
            _selectedTextImageView3.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        }
        
    } else if ([title isEqualToString:@"收费方式"]) {
        
        if ([model.charge_type isEqualToString:@"1"]) {
            _contentLabel.text = @"线上";
            _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
            _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
        } else if ([model.charge_type isEqualToString:@"2"]) {
            _contentLabel.text = @"线下";
            _selectedTextImageView1.image = [UIImage imageNamed:@"Sports_create_step2_point_sel"];
            _selectedTextImageView2.image = [UIImage imageNamed:@"Sports_create_step2_point_nor"];
        }
        
    } else if ([title isEqualToString:@"是否公开"]) {
        
        if ([model.privacy isEqualToString:@"0"]) {
            _contentLabel.text = @"否";
        } else {
            _contentLabel.text = @"是";
            _privacySwitch.on = true;
        }
        
    }
}

@end
