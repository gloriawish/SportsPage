//
//  SPPersonalInfoTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setUpWithTitle:(NSString *)title content:(NSString *)content imageName:(NSString *)imageName;

@end
