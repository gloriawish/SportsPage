//
//  SPPersonalDetailTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/11/19.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalDetailTableViewCell : UITableViewCell

- (void)setUpWithImageName:(NSString *)imageName content:(NSString *)content isHiddenButtonView:(BOOL)isHidden;
- (void)setUpWithImageNames:(NSArray<NSString *> *)imageNames contents:(NSArray <NSString *>*)contents;

@end
