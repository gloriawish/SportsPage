//
//  SPSportsClubUnbindSportsPageViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPSportsClubUnbindSportsPageViewControllerProtocol <NSObject>

- (void)finishedBindReloadAction;

@end

@interface SPSportsClubUnbindSportsPageViewController : SPBaseViewController

@property (weak) id <SPSportsClubUnbindSportsPageViewControllerProtocol> delegate;

- (instancetype)initWithClubId:(NSString *)clubId;

@end
