//
//  SPClubMembersListViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/6.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

typedef NS_ENUM(NSUInteger, SPClubMembersListViewControllerUserIdentity) {
    SPClubMembersListViewControllerUserIdentityCreator,
    SPClubMembersListViewControllerUserIdentityAdmin
};

@interface SPClubMembersListViewController : SPBaseViewController

- (void)setUpClubId:(NSString *)clubId userIdentity:(SPClubMembersListViewControllerUserIdentity)identity;

@end
