//
//  SPCreateSportsPageEventView.h
//  SportsPage
//
//  Created by Qin on 2017/2/6.
//  Copyright © 2017年 运动页. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPCreateSportsPageEventViewProtocol <NSObject>

- (void)receivedContentString:(NSString *)string;

@end

@interface SPCreateSportsPageEventView : UIView

@property (weak, nonatomic) IBOutlet UIView *eventView;

@property (weak) id <SPCreateSportsPageEventViewProtocol> delegate;

@end
