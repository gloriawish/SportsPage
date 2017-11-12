//
//  SPSportsPageFocusTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/22.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsPageFocusTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPSportsPageFocusTableViewCell () {
    SPSportsMainResponseModel *_model;
}

@property (weak, nonatomic) IBOutlet UIView *focusView;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;
@property (weak, nonatomic) IBOutlet UILabel *minNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *separtorLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView5;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView6;

@end

@implementation SPSportsPageFocusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp {
//    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
//    | UIViewAutoresizingFlexibleWidth
//    | UIViewAutoresizingFlexibleRightMargin
//    | UIViewAutoresizingFlexibleTopMargin
//    | UIViewAutoresizingFlexibleHeight
//    | UIViewAutoresizingFlexibleBottomMargin;
    
    _focusView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    //_focusView.layer.shouldRasterize = true;
    _focusView.layer.shadowOpacity = 0.5;
    _focusView.layer.shadowOffset = CGSizeMake(2, 2);
    
}

- (void)setUpWithModel:(SPSportsMainResponseModel *)model {
    _model = model;
    
    //运动图片
    if (model.portrait.length != 0) {
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]
                          placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _contentImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    //运动名称
    if (model.title.length != 0) {
        _titleLabel.text = model.title;
    } else {
        _titleLabel.text = @"还没有运动名称";
    }
    //[_titleLabel sizeToFit];
    
    //运动评星
    if (model.grade.length != 0) {
        NSString *imageStr = [NSString stringWithFormat:@"Sports_star_%@",model.grade];
        _starImageView.image = [UIImage imageNamed:imageStr];
    } else {
        _starImageView.hidden = true;
    }
    
    //运动地址
    if (model.location.length != 0) {
        _locationLabel.text = model.location;
    } else {
        _locationLabel.text = @"还没有地址";
    }
    
    //运动时间
    if (model.start_time.length != 0) {
        if (model.start_time.length == 19) {
            _timeLabel.text = [model.start_time substringWithRange:NSMakeRange(5, 11)];
            [_timeLabel sizeToFit];
        } else {
            _timeLabel.text = @"时间待定";
            [_timeLabel sizeToFit];
        }
    } else {
        _timeLabel.text = @"时间待定";
        [_timeLabel sizeToFit];
    }
    
    //运动发起人
    if (model.user_id.nick.length != 0) {
        _initiateLabel.text = model.user_id.nick;
    } else {
        _initiateLabel.text = model.user_id.uname;
    }
    
    //运动价格
    if (model.price.length != 0) {
        if ([model.price isEqualToString:@"0.00"]) {
            _priceLabel.text = @"免费";
            [_priceLabel sizeToFit];
        } else {
            _priceLabel.text = [NSString stringWithFormat:@"%@元/人",_model.price];
            [_priceLabel sizeToFit];
        }
    } else {
        _priceLabel.text = @"金额待定";
        [_priceLabel sizeToFit];
    }
    
    //运动参与人
    if (model.enrollUsers.count == 0) {
        _minNumLabel.text = @"还没有用户参与其中,快来参加吧";
        _separtorLabel.text = @"";
        _maxNumLabel.text = @"";
        [self setUpImageView:true isHidden2:true isHidden3:true isHidden4:true isHidden5:true isHidden6:true];
    } else {
        NSInteger userCount = model.enrollUsers.count;
        _minNumLabel.text = [NSString stringWithFormat:@"%lu",userCount];
        _separtorLabel.text = @"/";
        _maxNumLabel.text = model.max_number;
        switch (userCount) {
            case 1:
                [self setUpWithTimes:1];
                [self setUpImageView:false isHidden2:true isHidden3:true isHidden4:true isHidden5:true isHidden6:true];
                break;
            case 2:
                [self setUpWithTimes:2];
                [self setUpImageView:false isHidden2:false isHidden3:true isHidden4:true isHidden5:true isHidden6:true];
                break;
            case 3:
                [self setUpWithTimes:3];
                [self setUpImageView:false isHidden2:false isHidden3:false isHidden4:true isHidden5:true isHidden6:true];
                break;
            case 4:
                [self setUpWithTimes:4];
                [self setUpImageView:false isHidden2:false isHidden3:false isHidden4:false isHidden5:true isHidden6:true];
                break;
            case 5:
                [self setUpWithTimes:5];
                [self setUpImageView:false isHidden2:false isHidden3:false isHidden4:false isHidden5:false isHidden6:true];
                break;
            case 6:
                [self setUpWithTimes:6];
                [self setUpImageView:false isHidden2:false isHidden3:false isHidden4:false isHidden5:false isHidden6:false];
                break;
            default:
                break;
        }
        
    }
    [_minNumLabel sizeToFit];
    [_separtorLabel sizeToFit];
    [_maxNumLabel sizeToFit];
}

- (void)setUpImageView:(BOOL)isHidden1
             isHidden2:(BOOL)isHidden2
             isHidden3:(BOOL)isHidden3
             isHidden4:(BOOL)isHidden4
             isHidden5:(BOOL)isHidden5
             isHidden6:(BOOL)isHidden6 {
    _headImageView1.hidden = isHidden1;
    _headImageView2.hidden = isHidden2;
    _headImageView3.hidden = isHidden3;
    _headImageView4.hidden = isHidden4;
    _headImageView5.hidden = isHidden5;
    _headImageView6.hidden = isHidden6;
}

- (void)setUpWithTimes:(NSInteger)times {
    NSArray *tempArray = @[_headImageView1,
                           _headImageView2,
                           _headImageView3,
                           _headImageView4,
                           _headImageView5,
                           _headImageView6];
    for (int index=0; index<times; index++) {
        [self setUpWithIndex:index imageView:tempArray[index]];
    }
}

- (void)setUpWithIndex:(NSInteger)index imageView:(UIImageView *)sender {
    [sender layoutIfNeeded];
    sender.layer.cornerRadius = sender.frame.size.width/2;
    sender.layer.masksToBounds = true;
    NSURL *url = [NSURL URLWithString:[_model.enrollUsers[index] portrait]];
    [sender sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
}

@end
