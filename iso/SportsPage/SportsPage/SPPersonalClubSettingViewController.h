//
//  SPPersonalClubSettingViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@class SPUserInfoModel;

typedef NS_ENUM(NSUInteger, SPPersonalClubSettingViewControllerStyle) {
    SPPersonalClubSettingViewControllerStyleCreator,
    SPPersonalClubSettingViewControllerStyleAdmin,
    SPPersonalClubSettingViewControllerStyleNormal,
    SPPersonalClubSettingViewControllerStyleOutSide
};

@protocol SPPersonalClubSettingViewControllerProtocol <NSObject>

- (void)updateJoinType:(NSString *)joinType;

- (void)updateClubCoverImage:(UIImage *)coverImage;
- (void)updateClubTeamImage:(UIImage *)teamImage;
- (void)updateClubName:(NSString *)clubName;
- (void)updateClubEvent:(NSString *)clubEvent clubEventExtend:(NSString *)clubEventExtend;
- (void)updateClubPublicNotice:(NSString *)publicNotice;

@end

@interface SPPersonalClubSettingViewController : SPBaseViewController

@property (weak) id <SPPersonalClubSettingViewControllerProtocol> delegate;

- (instancetype)initWithViewControllerType:(SPPersonalClubSettingViewControllerStyle)style;

- (void)setUpCoverImage:(UIImage *)coverImage
              teamImage:(UIImage *)teamImage
               clubName:(NSString *)clubName
              clubEvent:(NSString *)clubEvent
             clubExtend:(NSString *)clubExtend
       clubPublicNotice:(NSString *)clubPublicNotice
           clubJoinType:(NSString *)clubJoinType;

- (void)setUpClubMembersArray:(NSMutableArray <SPUserInfoModel *>*)clubMembersArray
             clubMembersCount:(NSString *)clubMembersCount
                       clubId:(NSString *)clubId;


@end
