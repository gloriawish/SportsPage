//
//  SPPersonalClubInfoViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/3.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPPersonalClubInfoViewControllerProtocol <NSObject>

- (void)updateClubCover:(UIImage *)coverImage;

- (void)updateClubTeamImage:(UIImage *)teamImage;

- (void)updateClubName:(NSString *)clubName;

- (void)updateClubEvent:(NSString *)clubEventNum clubEventString:(NSString *)clubEventString;

- (void)updateClubPublicNotice:(NSString *)clubPublicNotice;

@end

@interface SPPersonalClubInfoViewController : SPBaseViewController

@property (weak) id <SPPersonalClubInfoViewControllerProtocol> delegate;

- (void)setUpCoverImage:(UIImage *)coverImage
              teamImage:(UIImage *)teamImage
               clubName:(NSString *)clubName
              clubEvent:(NSString *)clubEvent
             clubExtend:(NSString *)clubExtend
       clubPublicNotice:(NSString *)clubPublicNotice
                 clubId:(NSString *)clubId;

@end
