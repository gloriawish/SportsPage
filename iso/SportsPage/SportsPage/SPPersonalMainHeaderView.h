//
//  SPPersonalMainHeaderView.h
//  SportsPage
//
//  Created by Qin on 2016/12/30.
//  Copyright © 2016年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol personalMainHeaderProtocol <NSObject>

- (void)sendActionWithTitle:(NSString *)title;

@end

@interface SPPersonalMainHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic,weak) id<personalMainHeaderProtocol> delegate;

- (void)setUpHeaderImageView:(NSString *)imageUrl userName:(NSString *)userName;

@end
