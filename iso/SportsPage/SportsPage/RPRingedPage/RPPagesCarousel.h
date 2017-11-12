//
//  RPPagesCarousel.h
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPPagesCarousel;

@protocol RPPagesCarouselDataSource <NSObject>

- (NSInteger)numberOfPagesInCarousel:(RPPagesCarousel *)carousel;
- (UICollectionViewCell *)carousel:(RPPagesCarousel *)carousel pageForItemAtIndex:(NSInteger)index;

@end

@protocol  RPPagesCarouselDelegate<NSObject>

@optional
- (void)carousel:(RPPagesCarousel *)carousel didScrollToPageAtIndex:(NSInteger)index;
- (void)didSelectedCurrentPageInCarousel:(RPPagesCarousel *)carousel;

@end

@interface RPPagesCarousel : UIView

/**
 The size of the center main page. Infact, if you don't set, will be the size of whole PagesCarousel.
 */
@property (nonatomic,assign) CGSize mainPageSize;

/**
 When the center page is moved to left or right, it's size will change, so we use pageScale for this.
 */
@property (nonatomic, assign) CGFloat pageScale;

/**
 if <= 0, will not scroll automatically.
 */
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

@property (nonatomic,assign)   id <RPPagesCarouselDataSource> dataSource;
@property (nonatomic,assign)   id <RPPagesCarouselDelegate>   delegate;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)reloadData;
- (void)scrollToIndex:(NSUInteger)pageIndex;

/**
 To get the reusing views.
 Normally, pages are the same type views, so we can use an array to stroy reusingViews, not dictionary or chache
 
 @return A view as page for reusing.
 */
- (UIView *)dequeueReusablePage;

@end
