//
//  SPPersonalDetailTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/11/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalDetailTableViewCell.h"

@interface SPPersonalDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *buttonView1;
@property (weak, nonatomic) IBOutlet UIView *buttonView2;
@property (weak, nonatomic) IBOutlet UIView *buttonView3;
@property (weak, nonatomic) IBOutlet UIView *buttonView4;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel4;

@end

@implementation SPPersonalDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpGesture:_buttonView1];
    [self setUpGesture:_buttonView2];
    [self setUpGesture:_buttonView3];
    [self setUpGesture:_buttonView4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpGesture:(UIView *)sender {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    sender.userInteractionEnabled = true;
    [sender addGestureRecognizer:tapGesture];
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (sender.view == _buttonView1) {
        if ([_contentLabel1.text isEqualToString:@"进行中"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"进行中"}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"关注记录"}];
        }
    } else if (sender.view == _buttonView2) {
        if ([_contentLabel2.text isEqualToString:@"待结算"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"待结算"}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"我的运动页"}];
        }
    } else if (sender.view == _buttonView3) {
        if ([_contentLabel3.text isEqualToString:@"待评价"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"待评价"}];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"创建运动页"}];
        }
    } else {
        if ([_contentLabel4.text isEqualToString:@"全部记录"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_PUSH_NEXT object:nil userInfo:@{@"Action":@"全部记录"}];
        }
    }
}

- (void)setUpWithImageName:(NSString *)imageName content:(NSString *)content isHiddenButtonView:(BOOL)isHidden {
    if (isHidden) {
        _buttonView4.hidden = true;
    } else {
        _imageView4.image = [UIImage imageNamed:imageName];
        _contentLabel4.text = content;
    }
}

- (void)setUpWithImageNames:(NSArray<NSString *> *)imageNames contents:(NSArray <NSString *>*)contents {
    _imageView1.image = [UIImage imageNamed:imageNames[0]];
    _imageView2.image = [UIImage imageNamed:imageNames[1]];
    _imageView3.image = [UIImage imageNamed:imageNames[2]];
    
    _contentLabel1.text = contents[0];
    _contentLabel2.text = contents[1];
    _contentLabel3.text = contents[2];
}

@end
