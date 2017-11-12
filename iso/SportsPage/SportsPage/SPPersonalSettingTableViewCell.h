//
//  SPPersonalSettingTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/15.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalSettingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setUpWithContent:(NSString *)content;

@end
