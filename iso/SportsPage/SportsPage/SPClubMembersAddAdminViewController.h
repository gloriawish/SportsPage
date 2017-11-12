//
//  SPClubMembersAddAdminViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPClubMembersAddAdminViewControllerProtocol <NSObject>

- (void)finishedAddAdminAction;

@end

@interface SPClubMembersAddAdminViewController : SPBaseViewController

@property (weak) id <SPClubMembersAddAdminViewControllerProtocol> delegate;

- (void)setUpNormalMembersArray:(NSMutableArray *)normalMembersArray
                         clubId:(NSString *)clubId;

@end
