//
//  SPSportsPageShareView.h
//  SportsPage
//
//  Created by Qin on 2017/3/29.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPSportsPageShareViewProtocol <NSObject>

- (void)cancelShareView;

- (void)finishedShareToSportsPage;
- (void)finishedShareToWeChatFriends;
- (void)finishedShareToWeChatTimeLine;
- (void)finishedShareToQQ;
- (void)finishedShareToQQZone;

@end

@interface SPSportsPageShareView : UIView

@property (weak) id <SPSportsPageShareViewProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *shareView;

- (void)isNotNeedToSportsPageShareType;
- (void)onlyNeedToSportsPageShareType;

@end
