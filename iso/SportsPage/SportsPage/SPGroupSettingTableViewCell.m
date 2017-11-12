//
//  SPGroupSettingTableViewCell.m
//  SportsPage
//
//  Created by Qin on 2017/1/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPGroupSettingTableViewCell.h"

#import "SPUserInfoModel.h"

#import "UIImageView+WebCache.h"

@interface SPGroupSettingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *headView1;
@property (weak, nonatomic) IBOutlet UIView *headView2;
@property (weak, nonatomic) IBOutlet UIView *headView3;
@property (weak, nonatomic) IBOutlet UIView *headView4;
@property (weak, nonatomic) IBOutlet UIView *headView5;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView5;

@end

@implementation SPGroupSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUp {
    _headView1.hidden = true;
    _headView2.hidden = true;
    _headView3.hidden = true;
    _headView4.hidden = true;
    _headView5.hidden = true;
}

- (void)addGesture:(UIView *)sender {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderAction:)];
    [sender addGestureRecognizer:tap];
    sender.hidden = false;
    sender.userInteractionEnabled = true;
}

- (void)tapHeaderAction:(UITapGestureRecognizer *)sender {
    UIView *senderView = sender.view;
    NSString *targetId = [NSString stringWithFormat:@"%ld",senderView.tag];
    if ([_delegate respondsToSelector:@selector(groupSettingHeadActionWithTargetId:)]) {
        [_delegate groupSettingHeadActionWithTargetId:targetId];
    }
}

- (void)setUpWithModelArray:(NSMutableArray <SPUserInfoModel *>*)modelArray {
    NSArray <UIView *>*viewArray = @[_headView1,_headView2,_headView3,_headView4,_headView5];
    NSArray *imageViewArray = @[_headImageView1,_headImageView2,_headImageView3,_headImageView4,_headImageView5];
    for (int i=0; i<modelArray.count; i++) {
        UIView *tempView = viewArray[i];
        UIImageView *tempImageView = imageViewArray[i];
        [self setUpWithView:tempView imageView:tempImageView userModel:modelArray[i]];
    }
}

- (void)setUpWithView:(UIView *)view imageView:(UIImageView *)imageView userModel:(SPUserInfoModel *)model {
    [self addGesture:view];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = true;
    
    if (model.isAddIcon.length == 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]
                     placeholderImage:[UIImage imageNamed:@"IM_placeholder"]];
    } else {
        imageView.image = [UIImage imageNamed:@"IM_chatSettingGroup_addUsers"];
    }
    view.tag = [[model userId] integerValue];
}

@end
