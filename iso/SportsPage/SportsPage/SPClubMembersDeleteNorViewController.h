//
//  SPClubMembersDeleteNorViewController.h
//  SportsPage
//
//  Created by Qin on 2017/3/9.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPClubMembersDeleteNorViewControllerProtocol <NSObject>

- (void)finishedDeleteNorAction;

@end

@interface SPClubMembersDeleteNorViewController : SPBaseViewController

@property (weak) id <SPClubMembersDeleteNorViewControllerProtocol> delegate;

- (void)setUpNormalMembersArray:(NSMutableArray *)normalMembersArray
                         clubId:(NSString *)clubId;

@end
