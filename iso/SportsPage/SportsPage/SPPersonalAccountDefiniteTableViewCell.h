//
//  SPPersonalAccountDefiniteTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/12/1.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalAccountDefiniteTableViewCell : UITableViewCell

- (void)setUpWithType:(NSString *)type balance:(NSString *)balance time:(NSString *)time money:(NSString *)money remark:(NSString *)remark;

@end
