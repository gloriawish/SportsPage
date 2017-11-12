//
//  SPPersonalFollowsTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import "SPPersonalFollowsTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalFollowsTableViewCell () {
    NSString *_sportId;
}

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation SPPersonalFollowsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isFocus = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)changeFocusStatusAction:(UIButton *)sender {
    if (_isFocus) {
        __weak SPPersonalFollowsTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_FOCUS_RECORD_ACTION object:nil userInfo:@{@"focusAction":@"cancel",@"sportId":_sportId,@"cell":cell}];
    } else {
        __weak SPPersonalFollowsTableViewCell *cell = self;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MINE_FOCUS_RECORD_ACTION object:nil userInfo:@{@"focusAction":@"focus",@"sportId":_sportId,@"cell":cell}];
    }
}

- (void)setUpWithImageName:(NSString *)imageName type:(NSString *)type title:(NSString *)title initiate:(NSString *)initiate location:(NSString *)location sportId:(NSString *)sportId {
    _sportId = sportId;
    
    [_contentImageView layoutIfNeeded];
    _contentImageView.layer.cornerRadius = 5;
    _contentImageView.layer.masksToBounds = true;
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;

    if (imageName.length != 0) {
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"Sports_main_mask"]];
    } else {
        _contentImageView.image = [UIImage imageNamed:@"Sports_main_mask"];
    }
    
    NSString *typeImageName = nil;
    if ([type isEqualToString:@"1"]) {
        typeImageName = @"Mine_focus_record_badminton";
    } else if ([type isEqualToString:@"2"]) {
        typeImageName = @"Mine_focus_record_football";
    } else if ([type isEqualToString:@"3"]) {
        typeImageName = @"Mine_focus_record_basketball";
    } else if ([type isEqualToString:@"4"]) {
        typeImageName = @"Mine_focus_record_tinnes";
    } else if ([type isEqualToString:@"5"]) {
        typeImageName = @"Mine_focus_record_jogging";
    } else if ([type isEqualToString:@"6"]) {
        typeImageName = @"Mine_focus_record_swimming";
    } else if ([type isEqualToString:@"7"]) {
        typeImageName = @"Mine_focus_record_squash";
    } else if ([type isEqualToString:@"8"]) {
        typeImageName = @"Mine_focus_record_kayak";
    } else if ([type isEqualToString:@"9"]) {
        typeImageName = @"Mine_focus_record_baseball";
    } else if ([type isEqualToString:@"10"]) {
        typeImageName = @"Mine_focus_record_pingpang";
    } else if ([type isEqualToString:@"20"]) {
        typeImageName = @"Mine_focus_record_custom";
    }
    _typeImageView.image = [UIImage imageNamed:typeImageName];
    
    if (title.length != 0) {
        _contentLabel.text = title;
    } else {
        _contentLabel.text = @"";
    }
    //[_contentLabel sizeToFit];
    
    if (initiate.length != 0) {
        _initiateLabel.text = [NSString stringWithFormat:@"发起人: %@",initiate];
    } else {
        _initiateLabel.text = @"";
    }
    //[_initiateLabel sizeToFit];
    
    if (location.length != 0) {
        _locationLabel.text = location;
    } else {
        _locationLabel.text = @"";
    }
    //[_locationLabel sizeToFit];
    
}

@end
