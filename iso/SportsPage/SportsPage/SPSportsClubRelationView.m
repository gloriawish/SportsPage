//
//  SPSportsClubRelationView.m
//  SportsPage
//
//  Created by Qin on 2017/3/28.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPSportsClubRelationView.h"

#import "SPSportsPageResponseModel.h"

#import "UIImageView+WebCache.h"

@interface SPSportsClubRelationView () {
    SPSportsPageModel *_sportsPageModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *sportsPageImageView;
@property (weak, nonatomic) IBOutlet UILabel *sportsPageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportsPageLocationLabel;

@end

@implementation SPSportsClubRelationView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

#pragma mark - SetUp
- (void)setUp {
    _sportsPageImageView.layer.cornerRadius = 3;
    _sportsPageImageView.layer.masksToBounds = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRelationViewAction:)];
    [self addGestureRecognizer:tap];
}

- (void)setUpSportsPageModel:(SPSportsPageModel *)model {
    _sportsPageModel = model;
    
    [_sportsPageImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:nil];
    
    _sportsPageTitleLabel.text = model.title;
    _sportsPageLocationLabel.text = model.place;
    
}

#pragma mark - Action
- (void)tapRelationViewAction:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(clickSportsPageAction:status:eventId:)]) {
        [_delegate clickSportsPageAction:_sportsPageModel.sportId status:_sportsPageModel.status eventId:_sportsPageModel.event_id];
    }
}

@end
