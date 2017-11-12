//
//  SPCreateEventTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/9.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPLastEventModel.h"

@interface SPCreateEventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedTextLabel1;
@property (weak, nonatomic) IBOutlet UILabel *selectedTextLabel2;
@property (weak, nonatomic) IBOutlet UILabel *selectedTextLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *selectedTextImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTextImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedTextImageView3;

@property (weak, nonatomic) IBOutlet UISwitch *privacySwitch;

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setUpCellWithSelectedViewHidden1:(BOOL)isHidden1
                     selectedViewHidden2:(BOOL)isHidden2
                     selectedViewHidden3:(BOOL)isHidden3
                            switchHidden:(BOOL)isSwitchHidden
                      contentLabelHidden:(BOOL)isContentLabelHidden;

- (void)setUpCellWithContent1:(NSString *)content1
                     content2:(NSString *)content2
                     content3:(NSString *)content3;

- (void)setUpCellImageView:(NSString *)imageName title:(NSString *)title;

- (void)setUpCellContent:(NSString *)content;

- (void)setUpWithFillUpData:(NSString *)title model:(SPLastEventModel *)model;

@end
