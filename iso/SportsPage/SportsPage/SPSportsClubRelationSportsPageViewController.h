//
//  SPSportsClubRelationSportsPageViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPSportsClubRelationSportsPageViewControllerProtocol <NSObject>

- (void)finishedBindReloadAction;

@end

@interface SPSportsClubRelationSportsPageViewController : SPBaseViewController

@property (weak) id <SPSportsClubRelationSportsPageViewControllerProtocol> delegate;

- (instancetype)initWithClubId:(NSString *)clubId permission:(NSString *)permission;

@end
