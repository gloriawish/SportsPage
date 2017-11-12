//
//  SPUserInfoTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/10/21.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPUserInfoModel.h"

@interface SPUserInfoTableViewCell : UITableViewCell

- (void)setupWithUserInfoModel:(SPUserInfoModel *)model;

@end
