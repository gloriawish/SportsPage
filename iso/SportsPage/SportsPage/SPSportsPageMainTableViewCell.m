//
//  SPSportsPageMainTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/17.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageMainTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPSportsPageMainTableViewCell () {
    SPSportsMainResponseModel *_model;
}

@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *hotLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotInitiateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotMemberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hotStarImageView;

@end

@implementation SPSportsPageMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = true;

    if (SCREEN_WIDTH == 320) {
        _maskImageView.image = [UIImage imageNamed:@"Sports_main_shadow_5s"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpWithModel:(SPSportsMainResponseModel *)model {
    _model = model;
    
    //运动图片
    if (model.portrait.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]
                          placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    //运动地址
    if (model.location.length != 0) {
        _hotLocationLabel.text = model.location;
    } else {
        _hotLocationLabel.text = @"地址待定";
        [_hotLocationLabel sizeToFit];
    }
    
    //运动时间
    if (model.start_time.length != 0) {
        if (model.start_time.length == 19) {
            _hotTimeLabel.text = [model.start_time substringWithRange:NSMakeRange(5, 11)];
        } else {
            _hotTimeLabel.text = @"时间待定";
            [_hotTimeLabel sizeToFit];
        }
    } else {
        _hotTimeLabel.text = @"时间待定";
        [_hotTimeLabel sizeToFit];
    }
    _hotTimeLabel.textAlignment = NSTextAlignmentRight;
    
    //运动名称
    if (model.title.length != 0) {
        _hotNameLabel.text = model.title;
    } else {
        _hotNameLabel.text = @"运动名称待定";
        //[_hotNameLabel sizeToFit];
    }
    
    //运动发起人
    if (model.user_id.nick.length != 0) {
        _hotInitiateLabel.text = model.user_id.nick;
    } else {
        _hotInitiateLabel.text = model.user_id.uname;
    }
    _hotInitiateLabel.textAlignment = NSTextAlignmentRight;
    //[_hotInitiateLabel sizeToFit];
    
    //运动评星
    NSString *imageStr = nil;
    if (model.grade.length != 0) {
        imageStr = [NSString stringWithFormat:@"Sports_star_%@",model.grade];
        _hotStarImageView.image = [UIImage imageNamed:imageStr];
    } else {
        _hotStarImageView.hidden = true;
    }
    
    //运动参与人数
    if (model.max_number.length != 0) {
        _hotMemberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)model.enrollUsers.count,model.max_number];
        [_hotMemberLabel sizeToFit];
    } else {
        _hotMemberLabel.text = @"还没有确定参与人数";
        [_hotMemberLabel sizeToFit];
    }
    
}

@end
