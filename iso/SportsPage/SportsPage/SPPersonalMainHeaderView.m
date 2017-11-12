//
//  SPPersonalMainHeaderView.m
//  SportsPage
//
//  Created by Qin on 2016/12/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalMainHeaderView.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalMainHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;

@property (weak, nonatomic) IBOutlet UIView *mineSportsPageView;
@property (weak, nonatomic) IBOutlet UIView *createSportsPageView;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet UIView *proceedView;
@property (weak, nonatomic) IBOutlet UIView *settleView;
@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (weak, nonatomic) IBOutlet UIView *allView;

@end

@implementation SPPersonalMainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    
    _lineView1.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _lineView2.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    _lineView3.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
    
    [self setUpGesture:_headImageView selector:@selector(tapAction:)];
    
    [self setUpGesture:_mineSportsPageView selector:@selector(tapAction:)];
    [self setUpGesture:_createSportsPageView selector:@selector(tapAction:)];
    
    [self setUpGesture:_proceedView selector:@selector(tapAction:)];
    [self setUpGesture:_settleView selector:@selector(tapAction:)];
    [self setUpGesture:_evaluationView selector:@selector(tapAction:)];
    [self setUpGesture:_allView selector:@selector(tapAction:)];
    
}

- (void)setUpGesture:(UIView *)sender selector:(SEL)sel {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    sender.userInteractionEnabled = true;
    [sender addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(sendActionWithTitle:)]) {
        if (sender.view == _headImageView) {
            [_delegate sendActionWithTitle:@"头像"];
        } else if (sender.view == _mineSportsPageView) {
            [_delegate sendActionWithTitle:@"我的运动页"];
        } else if (sender.view == _createSportsPageView) {
            [_delegate sendActionWithTitle:@"创建运动页"];
        } else if (sender.view == _proceedView) {
            [_delegate sendActionWithTitle:@"进行中"];
        } else if (sender.view == _settleView) {
            [_delegate sendActionWithTitle:@"待结算"];
        } else if (sender.view == _evaluationView) {
            [_delegate sendActionWithTitle:@"待评价"];
        } else if (sender.view == _allView) {
            [_delegate sendActionWithTitle:@"全部记录"];
        }
    }
}

- (void)setUpHeaderImageView:(NSString *)imageUrl userName:(NSString *)userName {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"Mine_headerImageView"]];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    _headImageView.layer.masksToBounds = true;
    
    _headNameLabel.text = userName;
}

@end
