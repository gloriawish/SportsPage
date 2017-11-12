//
//  SPPersonalClubInfoUpdateViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/24.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

typedef NS_ENUM(NSUInteger, SPPersonalClubInfoUpdateViewControllerStyle) {
    SPPersonalClubInfoUpdateViewControllerStyleUpdateClubName  = 1,
    SPPersonalClubInfoUpdateViewControllerStyleUpdateClubEvent = 2,
    SPPersonalClubInfoUpdateViewControllerStyleUpdateClubOther = 3
};

@protocol SPPersonalClubInfoUpdateViewControllerProtocol <NSObject>

- (void)finishedUpdateClubNameAction:(NSString *)clubName;
- (void)finishedUpdateClubEventAction:(NSString *)clubEventString clubEventNum:(NSString *)clubEventNum;

@end

@interface SPPersonalClubInfoUpdateViewController : SPBaseViewController

@property (weak) id <SPPersonalClubInfoUpdateViewControllerProtocol> delegate;

- (instancetype)initWithStyle:(SPPersonalClubInfoUpdateViewControllerStyle)style
                 sourceString:(NSString *)sourceString
                       clubId:(NSString *)clubId;

@end
