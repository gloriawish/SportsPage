//
//  SPPersonalMainTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalMainTableViewCell : UITableViewCell

- (void)setUpWithImageName:(NSString *)imageName title:(NSString *)title;

- (void)setUpWithContent:(NSString *)content;

- (void)setUpLineHidden:(BOOL)isHidden;
- (void)setUpMoreImageHidden:(BOOL)isHidden;

- (void)setUpMoreImage:(NSString *)imageName;

@end
