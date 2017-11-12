//
//  SPSportsPageShareCollectionViewCell.h
//  SportsPage
//
//  Created by Qin on 2017/3/29.
//  Copyright © 2017年 Absolute. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SPSportsPageShareType) {
    SPSportsPageShareTypeSportsPage     = 1,
    SPSportsPageShareTypeWeChatFriends  = 2,
    SPSportsPageShareTypeWeChatTimeLine = 3,
    SPSportsPageShareTypeQQ             = 4,
    SPSportsPageShareTypeQQZone         = 5
};

@interface SPSportsPageShareCollectionViewCell : UICollectionViewCell

- (void)setUpShareType:(SPSportsPageShareType)type;

@end
