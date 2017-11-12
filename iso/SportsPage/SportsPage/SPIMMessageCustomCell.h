//
//  SPIMMessageCustomCell.h
//  SportsPage
//
//  Created by Qin on 2016/12/12.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface SPIMMessageCustomCell : RCMessageCell

@property(strong, nonatomic) RCAttributedLabel *typeLabel;
@property(strong, nonatomic) RCAttributedLabel *textLabel;
@property(strong, nonatomic) UIImageView *eventImageView;
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@end
