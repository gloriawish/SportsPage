//
//  RPPageControl.h
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

/**
 Thanks for SMPageControl (https://github.com/Spaceman-Labs/SMPageControl)
 In fact, this one is a lite of the linked one.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RPPageControlAlignment) {
    RPPageControlAlignmentLeft = 1,
    RPPageControlAlignmentCenter,
    RPPageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, RPPageControlVerticalAlignment) {
    RPPageControlVerticalAlignmentTop = 1,
    RPPageControlVerticalAlignmentMiddle,
    RPPageControlVerticalAlignmentBottom
};

@interface RPPageControl : UIControl

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat indicatorMargin;
@property (nonatomic, assign) CGFloat indicatorDiameter;
@property (nonatomic, assign) CGFloat minHeight;                                    // default is 36, cannot be less than indicatorDiameter
@property (nonatomic, assign) RPPageControlAlignment alignment;                     // deafult is Center
@property (nonatomic, assign) RPPageControlVerticalAlignment verticalAlignment;     // deafult is Middle

@property (nonatomic, strong) UIImage *pageIndicatorImage;
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;
@property (nonatomic, copy) UIColor *indicatorTintColor;                    // will be ignored if pageIndicatorImage setted
@property (nonatomic, copy) UIColor *currentIndicatorTintColor;             // will be ignored if currentPageIndicatorImage setted

@end 
