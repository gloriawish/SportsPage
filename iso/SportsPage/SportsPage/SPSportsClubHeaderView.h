//
//  SPSportsClubHeaderView.h
//  SportsPage
//
//  Created by Qin on 2017/2/8.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPClubDetailResponseModel;

@protocol SPSportsClubHeaderViewProtocol <NSObject>

- (void)clubHeaderJoinAction;

- (void)clubHeaderChattingActionWithTargetId:(NSString *)targetId;

- (void)clubHeaderShareAction;

- (void)clubHeaderMembersListAction;

- (void)clubHeaderReviewRelationSportsPageAction;

- (void)clubHeaderClickRelationSportsPageAction:(NSString *)sportsPageId status:(NSString *)status eventId:(NSString *)eventId;

@end

@interface SPSportsClubHeaderView : UIView

@property (weak) id <SPSportsClubHeaderViewProtocol> delegate;

- (void)setUpClubDetailResponseModel:(SPClubDetailResponseModel *)model;

- (UIImage *)getClubCoverImageView;
- (UIImage *)getClubTeamImageView;
- (void)setUpClubCoverImageView:(UIImage *)image;
- (void)setUpClubTeamImageView:(UIImage *)image;
- (void)setUpClubName:(NSString *)clubName;
- (void)setUpClubPublicNotice:(NSString *)clubPublicNotice;

@end
