//
//  SPSportsSignedUpTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPSportsSignedUpViewController.h"

@interface SPSportsSignedUpTableViewCell : UITableViewCell

@property (nonatomic,weak) SPSportsSignedUpViewController *signedUpViewController;

- (void)setUpWithImageName:(NSString *)imageName initiate:(NSString *)initiate type:(NSString *)type targetId:(NSString *)targetId;

- (NSString *)getTargetId;

@end
