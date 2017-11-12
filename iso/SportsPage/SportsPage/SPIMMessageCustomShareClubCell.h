//
//  SPIMMessageCustomShareClubCell.h
//  SportsPage
//
//  Created by Qin on 2017/3/31.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SPIMMessageCustomShareClubCell : RCMessageCell

@property(strong, nonatomic) RCAttributedLabel *typeLabel;
@property(strong, nonatomic) RCAttributedLabel *textLabel;
@property(strong, nonatomic) UIImageView *clubImageView;
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@end
