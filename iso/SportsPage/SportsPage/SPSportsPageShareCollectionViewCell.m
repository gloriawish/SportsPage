//
//  SPSportsPageShareCollectionViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/3/29.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsPageShareCollectionViewCell.h"

@interface SPSportsPageShareCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImageView;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@end

@implementation SPSportsPageShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp {
    
}

- (void)setUpShareType:(SPSportsPageShareType)type {
    if (type == SPSportsPageShareTypeSportsPage) {
        _shareImageView.image = [UIImage imageNamed:@"Sports_main_share_sportsPage"];
        _shareLabel.text = @"运动页";
    } else if (type == SPSportsPageShareTypeWeChatFriends) {
        _shareImageView.image = [UIImage imageNamed:@"Sports_main_share_weChatFriends"];
        _shareLabel.text = @"微信好友";
    } else if (type == SPSportsPageShareTypeWeChatTimeLine) {
        _shareImageView.image = [UIImage imageNamed:@"Sports_main_share_weChat"];
        _shareLabel.text = @"微信朋友圈";
    } else if (type == SPSportsPageShareTypeQQ) {
        _shareImageView.image = [UIImage imageNamed:@"Sports_main_share_QQ"];
        _shareLabel.text = @"QQ";
    } else if (type == SPSportsPageShareTypeQQZone) {
        _shareImageView.image = [UIImage imageNamed:@"Sports_main_share_QQZone"];
        _shareLabel.text = @"QQ空间";
    }
}

@end
