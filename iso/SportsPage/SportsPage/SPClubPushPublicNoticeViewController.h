//
//  SPClubPushPublicNoticeViewController.h
//  SportsPage
//
//  Created by Qin on 2017/2/17.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPClubPushPublicNoticeViewControllerProtocol <NSObject>

- (void)updatePublicNotice:(NSString *)publicNotice;

@end

@interface SPClubPushPublicNoticeViewController : SPBaseViewController

@property (weak) id <SPClubPushPublicNoticeViewControllerProtocol> delegate;

@property (nonatomic,copy) NSString *clubId;
@property (nonatomic,copy) NSString *viewControllerTitle;

@end
