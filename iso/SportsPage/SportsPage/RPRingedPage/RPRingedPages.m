//
//  RPRingedPages.m
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "RPRingedPages.h"

@interface RPRingedPages () <RPPagesCarouselDelegate, RPPagesCarouselDataSource>

@property (nonatomic, strong, readwrite) RPPageControl *pageControl;
@property (nonatomic, strong, readwrite) RPPagesCarousel *carousel;

@end

@implementation RPRingedPages

- (void)p_setDefaults {
    self.showPageControl = YES;
    self.pageControlPosition = RPPageControlPositonBellowBody;
    self.pageControlHeight = 15;
    self.pageControlMarginTop = 5;
    self.pageControlMarginBottom = 5;
}

- (instancetype)initWithFrame:(CGRect )frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setDefaults];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setDefaults];
    }
    return self;
}

- (void)reloadData {
    [self p_layoutPageControlAndCarousel];
    [self.carousel reloadData];
}

- (void)p_layoutPageControlAndCarousel {
    [self layoutIfNeeded];
    self.pageControl.numberOfPages = 0;
    [self.pageControl removeFromSuperview];
    [self.carousel removeFromSuperview];
    
    if (![self.dataSource respondsToSelector:@selector(numberOfItemsInRingedPages:)]) {
        return;
    }
    NSInteger number = [self.dataSource numberOfItemsInRingedPages:self];    
    if (number < 1) {
        return;
    }
    self.pageControl.numberOfPages = number;
    self.pageControl.currentIndex = 0;
    CGRect carouselFrame;
    CGRect pageControlFrame;
    CGSize size = self.frame.size;
    CGFloat pageControlSpaceHeight = self.pageControlMarginBottom + self.pageControlMarginTop + self.pageControlHeight;
    switch (self.pageControlPosition) {
        case RPPageControlPositonAboveBody:
            pageControlFrame = CGRectMake(0, self.pageControlMarginTop, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, pageControlSpaceHeight, size.width, size.height - pageControlSpaceHeight);
            break;
        case RPPageControlPositonInBodyTop:
            pageControlFrame = CGRectMake(0, self.self.pageControlMarginTop, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height);
            break;
        case RPPageControlPositonInBodyBottom:
            pageControlFrame = CGRectMake(0, size.height - self.pageControlMarginBottom - self.pageControlHeight, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height);
            break;
        default:
            pageControlFrame = CGRectMake(0, size.height - self.pageControlHeight - self.pageControlMarginBottom, size.width, self.pageControlHeight);
            carouselFrame = CGRectMake(0, 0, size.width, size.height - pageControlSpaceHeight);
            break;
    }
    self.carousel.frame = carouselFrame;
    self.pageControl.frame = pageControlFrame;
    [self addSubview:self.carousel];
    [self addSubview:self.pageControl];
    self.pageControl.hidden = NO;
    if (!self.showPageControl) {
        self.pageControl.hidden = YES;
        self.carousel.frame = CGRectMake(0, 0, size.width, size.height);
    }
}

#pragma mark: RPPagesCarousel datasource and delegate
- (NSInteger)numberOfPagesInCarousel:(RPPagesCarousel *)carousel {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInRingedPages:)]) {
        return [self.dataSource numberOfItemsInRingedPages:self];
    }
    return 0;
}
- (UIView *)carousel:(RPPagesCarousel *)carousel pageForItemAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(ringedPages:viewForItemAtIndex:)]) {
        return [self.dataSource ringedPages:self viewForItemAtIndex:index];
    }
    return nil;
}
- (void)carousel:(RPPagesCarousel *)carousel didScrollToPageAtIndex:(NSInteger)index {
    self.pageControl.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(pages:didScrollToIndex:)]) {
        [self.delegate pages:self didScrollToIndex:index];
    }
}
- (void)didSelectedCurrentPageInCarousel:(RPPagesCarousel *)carousel {
    if ([self.delegate respondsToSelector:@selector(didSelectedCurrentPageInPages:)]) {
        [self.delegate didSelectedCurrentPageInPages:self];
    }
}

#pragma mark - getters and setters
- (RPPagesCarousel *)carousel {
    if (_carousel == nil) {
        _carousel = [RPPagesCarousel new];
        _carousel.dataSource = self;
        _carousel.delegate = self;
    }
    return _carousel;
}
- (RPPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [RPPageControl new];
        [_pageControl addTarget:self action:@selector(p_pageControTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSInteger)currentIndex {
    return self.carousel.currentIndex;
}

#pragma mark - helpers
- (void)p_pageControTapped:(RPPageControl *)pageControl {
    NSInteger index = pageControl.currentIndex;
    [self.carousel scrollToIndex:index];
}

- (UIView *)dequeueReusablePage {
    return [self.carousel dequeueReusablePage];
}

- (void)scrollToIndex:(NSUInteger)index {
    [self.carousel scrollToIndex:index];
}

@end
