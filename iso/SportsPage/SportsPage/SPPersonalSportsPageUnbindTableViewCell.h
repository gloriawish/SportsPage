//
//  SPPersonalSportsPageUnbindTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/3/30.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPSportsPageResponseModel.h"

@interface SPPersonalSportsPageUnbindTableViewCell : UITableViewCell

- (void)setUpWithModel:(SPSportsPageModel *)model;
- (void)changeSelectedImageStatus;
- (BOOL)isSelectedImage;

@end
