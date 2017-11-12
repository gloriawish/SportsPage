//
//  SPClubMembersDeleteAdminViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPClubMembersDeleteAdminViewControllerProtocol <NSObject>

- (void)finishedDeleteAdminAction;

@end

@interface SPClubMembersDeleteAdminViewController : SPBaseViewController

@property (weak) id <SPClubMembersDeleteAdminViewControllerProtocol> delegate;

- (void)setUpAdminArray:(NSMutableArray *)adminArray
                 clubId:(NSString *)clubId;

@end
