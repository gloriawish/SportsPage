//
//  SPSportsClubRelationView.h
//  SportsPage
//
//  Created by Qin on 2017/3/28.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSportsPageModel;

@protocol SPSportsClubRelationViewProtocol <NSObject>

- (void)clickSportsPageAction:(NSString *)sportsPageId status:(NSString *)status eventId:(NSString *)eventId;

@end

@interface SPSportsClubRelationView : UIView

@property (weak) id <SPSportsClubRelationViewProtocol> delegate;

- (void)setUpSportsPageModel:(SPSportsPageModel *)model;

@end
