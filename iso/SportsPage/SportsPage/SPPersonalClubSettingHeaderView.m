//
//  SPPersonalClubSettingHeaderView.m
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPPersonalClubSettingHeaderView.h"

#import "SPUserInfoModel.h"

#import "UIImageView+WebCache.h"

@interface SPPersonalClubSettingHeaderView () {
    NSMutableArray <SPUserInfoModel *> *_clubMembersArray;
}

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet UIView *clubHeadView1;
@property (weak, nonatomic) IBOutlet UIView *clubHeadView2;

@property (weak, nonatomic) IBOutlet UILabel *clubMembersLabel;

@property (weak, nonatomic) IBOutlet UIImageView *clubMembersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *clubMembersImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *clubMembersImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *clubMembersImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *clubMembersImageView5;

@end

@implementation SPPersonalClubSettingHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp {
    [self setUpLineView:_lineView1];
    [self setUpLineView:_lineView2];
    [self setUpLineView:_lineView3];
    
    [self setUpGesture:_clubHeadView1 sel:@selector(clubViewTapAction:)];
    [self setUpGesture:_clubHeadView2 sel:@selector(clubViewTapAction:)];
    
}

- (void)setUpLineView:(UIView *)sender {
    sender.backgroundColor = [SPGlobalConfig anyColorWithRed:239 green:239 blue:243 alpha:1];
}

- (void)setUpGesture:(UIView *)sender sel:(SEL)sel {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    [sender addGestureRecognizer:tap];
    sender.userInteractionEnabled = true;
}

- (void)setUpClubImageView {
    
    [self setUpClubMembersImageViewHidden];
    NSArray <UIImageView *> *imageViewArray = @[_clubMembersImageView1,
                                                _clubMembersImageView2,
                                                _clubMembersImageView3,
                                                _clubMembersImageView4,
                                                _clubMembersImageView5];
    
    if (_clubMembersArray.count >= 5) {
        for (int i=0; i<4; i++) {
            [self setUpClubMembersImageView:imageViewArray[i]
                                   imageUrl:[_clubMembersArray[i] portrait]
                                     radius:SCREEN_WIDTH/10-10];
        }
        [self setUpAddMembersImageView:4];
    } else {
        for (int i=0; i<_clubMembersArray.count; i++) {
            [self setUpClubMembersImageView:imageViewArray[i]
                                   imageUrl:[_clubMembersArray[i] portrait]
                                     radius:SCREEN_WIDTH/10-10];
        }
        [self setUpAddMembersImageView:_clubMembersArray.count];
    }
}

- (void)setUpClubMembersImageViewHidden {
    _clubMembersImageView1.hidden = true;
    _clubMembersImageView2.hidden = true;
    _clubMembersImageView3.hidden = true;
    _clubMembersImageView4.hidden = true;
    _clubMembersImageView5.hidden = true;
}

- (void)setUpClubMembersImageView:(UIImageView *)sender imageUrl:(NSString *)imageUrl radius:(CGFloat)radius {
    sender.hidden = false;
    [sender sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    sender.layer.cornerRadius = radius;
    sender.layer.masksToBounds = true;
    sender.hidden = false;
}

- (void)setUpAddMembersImageView:(NSInteger)count {
    NSArray <UIImageView *> *imageViewArray = @[_clubMembersImageView1,
                                                _clubMembersImageView2,
                                                _clubMembersImageView3,
                                                _clubMembersImageView4,
                                                _clubMembersImageView5];
    
    UIImageView *addImageView = imageViewArray[count];
    addImageView.image = [UIImage imageNamed:@"club_setting_add_members"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clubMembersImageTapAction:)];
    [addImageView addGestureRecognizer:tap];
    addImageView.hidden = false;
    addImageView.userInteractionEnabled = true;
}

- (void)setUpMembersArray:(NSMutableArray *)membersArray
        totalMembersCount:(NSString *)membersCount {
    _clubMembersArray = membersArray;
    [self setUpClubImageView];
    
    if (membersCount.length != 0) {
        _clubMembersLabel.text = [NSString stringWithFormat:@"%@名成员",membersCount];
    } else {
        _clubMembersLabel.text = @"";
    }
}

#pragma mark - Action
- (void)clubViewTapAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(clickClubViewAction)]) {
        [_delegate clickClubViewAction];
    }
}

- (void)clubMembersImageTapAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(clickClubmembersImageViewAction)]) {
        [_delegate clickClubmembersImageViewAction];
    }
}

@end
