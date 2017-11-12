//
//  SPContactTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/10/27.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserInfoModel.h"

#import "SPGroupModel.h"

@interface SPContactTableViewCell : UITableViewCell

- (void)setUpWithImageName:(NSString *)imageName content:(NSString *)content;
- (void)setupWithModel:(SPUserInfoModel *)model;

- (void)setUpWithGroupImageName:(NSString *)imageName title:(NSString *)title;

@end
