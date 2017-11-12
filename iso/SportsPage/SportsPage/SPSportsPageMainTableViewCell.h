//
//  SPSportsPageMainTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/17.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPSportsMainResponseModel.h"

@interface SPSportsPageMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

- (void)setUpWithModel:(SPSportsMainResponseModel *)model;

@end
