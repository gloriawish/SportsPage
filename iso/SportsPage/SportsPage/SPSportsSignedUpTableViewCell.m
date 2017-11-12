//
//  SPSportsSignedUpTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPSportsSignedUpTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPSportsSignedUpTableViewCell () {
    NSString *_targetId;
}

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation SPSportsSignedUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_actionButton setBackgroundColor:[SPGlobalConfig themeColor]];
    [_actionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _actionButton.layer.cornerRadius = 5;
    _actionButton.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"+好友"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_MANAGER_ADD_FRIENDS object:nil userInfo:@{@"targetId":_targetId}];
    } else if ([sender.currentTitle isEqualToString:@"查看资料"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SPORTS_MANAGER_CHECK_FRIENDS object:nil userInfo:@{@"targetId":_targetId}];
    }
}

- (void)setUpWithImageName:(NSString *)imageName initiate:(NSString *)initiate type:(NSString *)type targetId:(NSString *)targetId {
    _targetId = targetId;
    if (imageName.length != 0) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
    } else {
        _headImageView.image = [UIImage imageNamed:@"IM_placeholder"];
    }
    [_headImageView layoutIfNeeded];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width/2;
    _headImageView.layer.masksToBounds = true;
    
    if (initiate.length != 0) {
        _initiateLabel.text = initiate;
    } else {
        _initiateLabel.text = @"";
    }
    [_initiateLabel sizeToFit];
    
    if ([type isEqualToString:@"-1"]) {
        _actionButton.hidden = true;
    } else if ([type isEqualToString:@"0"]) {
        [_actionButton setTitle:@"+好友" forState:UIControlStateNormal];
    } else if ([type isEqualToString:@"1"]) {
        [_actionButton setTitle:@"查看资料" forState:UIControlStateNormal];
        [_actionButton setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.7]];
    }
    
}

- (NSString *)getTargetId {
    return _targetId;
}

@end
