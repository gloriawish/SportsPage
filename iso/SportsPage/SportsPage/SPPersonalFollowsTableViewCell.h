//
//  SPPersonalFollowsTableViewCell.h
//  SportsPage
//
//  Created by Qin on 2016/12/6.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPPersonalFollowsTableViewCell : UITableViewCell

@property (nonatomic,assign) BOOL isFocus;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;

- (void)setUpWithImageName:(NSString *)imageName type:(NSString *)type title:(NSString *)title initiate:(NSString *)initiate location:(NSString *)location sportId:(NSString *)sportId;

@end
