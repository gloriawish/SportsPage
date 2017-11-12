//
//  SPPersonalClubSettingHeaderView.h
//  SportsPage
//
//  Created by Qin on 2017/3/2.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPPersonalClubSettingHeaderViewProtocol <NSObject>

- (void)clickClubViewAction;

- (void)clickClubmembersImageViewAction;

@end

@interface SPPersonalClubSettingHeaderView : UIView

@property (weak) id <SPPersonalClubSettingHeaderViewProtocol> delegate;

- (void)setUpMembersArray:(NSMutableArray *)membersArray
        totalMembersCount:(NSString *)membersCount;

@end
