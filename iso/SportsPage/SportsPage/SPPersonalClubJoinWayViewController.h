//
//  SPPersonalClubJoinWayViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

typedef NS_ENUM(NSInteger, SPPersonalClubJoinWayStyle) {
    SPPersonalClubJoinWayStyleHasConfirm     = 1,
    SPPersonalClubJoinWayStyleNoConfirm      = 2
};

@protocol SPPersonalClubJoinWayViewControllerProtocol <NSObject>

- (void)updateJoinType:(SPPersonalClubJoinWayStyle)style;

@end

@interface SPPersonalClubJoinWayViewController : SPBaseViewController

@property (weak) id <SPPersonalClubJoinWayViewControllerProtocol> delegate;

- (instancetype)initWithStyle:(SPPersonalClubJoinWayStyle)style clubId:(NSString *)clubI;

@end
