//
//  RPPagesCarousel.m
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "RPPagesCarousel.h"

@interface RPPagesCarousel ()<UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong) NSMutableArray *pages;
@property (nonatomic,assign) NSRange visibleRange;
@property (nonatomic,strong) NSMutableArray *reusablePages;
@property (nonatomic, assign) NSInteger orginPageCount;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger indexForTimer;
@property (nonatomic,assign) BOOL needsReload;

@end

@implementation RPPagesCarousel

#pragma mark - Override Methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self p_setUp];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_needsReload) {
        self.orginPageCount = 0;
        if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInCarousel:)]) {
            self.orginPageCount = [_dataSource numberOfPagesInCarousel:self];
            _pageCount = self.orginPageCount == 1 ? 1: self.orginPageCount * 3;
        }
        
        [_reusablePages removeAllObjects];
        [_pages removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
        
        for (NSInteger index=0; index<_pageCount; index++) {
            [_pages addObject:[NSNull null]];
        }
        _scrollView.frame = CGRectMake(0, 0, _mainPageSize.width, _mainPageSize.height);
        _scrollView.contentSize = CGSizeMake(_mainPageSize.width * _pageCount,_mainPageSize.height);
        CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _scrollView.center = center;
        
        if (self.orginPageCount > 1) {
            [_scrollView setContentOffset:CGPointMake(_mainPageSize.width * self.orginPageCount, 0) animated:NO];
            self.indexForTimer = self.orginPageCount;
            [self p_addTimer];
        }
        
        _needsReload = NO;
    }
    
    [self p_setPagesAtContentOffset:_scrollView.contentOffset];
    [self p_refreshVisiblePageAppearance];
    
}

#pragma mark -
#pragma mark RPPagesCarousel API

- (void)reloadData {
    _needsReload = YES;
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self p_removeTimer];
    [self setNeedsLayout];
}

- (void)scrollToIndex:(NSUInteger)pageIndex {
    if (pageIndex < _pageCount) {
        [self p_removeTimer];
        self.indexForTimer = pageIndex + self.orginPageCount;
        [_scrollView setContentOffset:CGPointMake(_mainPageSize.width * (pageIndex + self.orginPageCount), 0) animated:YES];
        [self p_setPagesAtContentOffset:_scrollView.contentOffset];
        [self p_refreshVisiblePageAppearance];
        [self p_addTimer];
    }
}

#pragma mark - private methods

- (void)p_setUp {
    self.mainPageSize = CGSizeZero;
    _pageScale = 1.0;
    _autoScrollInterval = 5.0;
    
    self.needsReload = YES;
    self.pageCount = 0;
    _currentIndex = 0;
    self.visibleRange = NSMakeRange(0, 0);
    self.reusablePages = [NSMutableArray array];
    self.pages = [NSMutableArray array];
    
    UIView *containner = [[UIView alloc] initWithFrame:self.bounds];
    containner.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [containner addSubview:self.scrollView];
    [self addSubview:containner];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_pagesTappedAction:)];
    [self addGestureRecognizer: tapGestureRecognizer];
}
- (void)p_addTimer {
    if (self.orginPageCount > 1 && self.autoScrollInterval > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(p_autoScrollToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)p_removeTimer {
    [self.timer invalidate];
}

- (void)p_autoScrollToNextPage {
    self.indexForTimer ++;
    [_scrollView setContentOffset:CGPointMake(self.indexForTimer * _mainPageSize.width, 0) animated:YES];
}

- (void)p_queueReusablePage:(UIView *)page {
    [_reusablePages addObject:page];
}

- (UIView *)dequeueReusablePage {
    UIView *page = [_reusablePages lastObject];
    if (page) {
        [_reusablePages removeLastObject];
    }
    return page;
}

- (void)p_removePageAtIndex:(NSInteger)index{
    UIView *page = [_pages objectAtIndex:index];
    if ((NSObject *)page == [NSNull null]) {
        return;
    }
    
    [self p_queueReusablePage:page];
    
    if (page.superview) {
        [page removeFromSuperview];
    }
    
    [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)p_refreshVisiblePageAppearance {
    
    if (_pageScale >= 1.0 || _pageScale < 0.0) {
        return;
    }
    CGFloat offset = _scrollView.contentOffset.x;
    
    for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
        UIView *page = _pages[i];
        CGFloat originX = page.frame.origin.x;
        CGFloat delta = fabs(originX - offset);
        
        CGRect originPageFrame = CGRectMake(_mainPageSize.width * i, 0, _mainPageSize.width, _mainPageSize.height);
        CGFloat inset = _mainPageSize.width * (1 - _pageScale) * 0.5;
        if (delta < _mainPageSize.width) {
            inset *= (delta / _mainPageSize.width);
        }
        page.frame = UIEdgeInsetsInsetRect(originPageFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
    }
}

- (void)p_setPageAtIndex:(NSInteger)index{
    NSParameterAssert(index >= 0 && index < _pages.count);
    
    UIView *page = [_pages objectAtIndex:index];
    
    if ((NSObject *)page == [NSNull null]) {
        page = [_dataSource carousel:self pageForItemAtIndex:index % self.orginPageCount];
        NSAssert(page!=nil, @"datasource must not return nil");
        [_pages replaceObjectAtIndex:index withObject:page];
        
        page.frame = CGRectMake(_mainPageSize.width * index, 0, _mainPageSize.width, _mainPageSize.height);
        
        if (!page.superview) {
            [_scrollView addSubview:page];
        }
    }
}

- (void)p_setPagesAtContentOffset:(CGPoint)offset{
    
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    
    NSInteger startIndex = 0;
    for (int i =0; i < _pages.count; i++) {
        if (_mainPageSize.width * (i +1) > startPoint.x) {
            startIndex = i;
            break;
        }
    }
    
    NSInteger endIndex = startIndex;
    for (NSInteger i = startIndex; i < _pages.count; i++) {
        
        if ((_mainPageSize.width * (i + 1) < endPoint.x && _mainPageSize.width * (i + 2) >= endPoint.x) || i+ 2 == _pages.count) {
            endIndex = i + 1;
            break;
        }
    }
    
    startIndex = MAX(startIndex - 1, 0);
    endIndex = MIN(endIndex + 1, _pages.count - 1);
    self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
    
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        [self p_setPageAtIndex:i];
    }
    
    for (NSInteger i = 0; i < startIndex; i ++) {
        [self p_removePageAtIndex:i];
    }
    
    for (NSInteger i = endIndex + 1; i < _pages.count; i ++) {
        [self p_removePageAtIndex:i];
    }
}

- (void)p_pagesTappedAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(didSelectedCurrentPageInCarousel:)]) {
            [self.delegate didSelectedCurrentPageInCarousel:self];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.orginPageCount == 0) {
        return;
    }
    CGFloat number = _scrollView.contentOffset.x / _mainPageSize.width;
    NSInteger pageIndex = (NSInteger)floor(number) % self.orginPageCount;
    
    if (self.orginPageCount > 1) {
        if (number >= 2 * self.orginPageCount) {
            [scrollView setContentOffset:CGPointMake(_mainPageSize.width * self.orginPageCount, 0) animated:NO];
            self.indexForTimer = self.orginPageCount;
        }
        
        if (number <= self.orginPageCount - 1) {
            [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _mainPageSize.width, 0) animated:NO];
            self.indexForTimer = 2 * self.orginPageCount;
        }
    } else {
        pageIndex = 0;
    }
    
    [self p_setPagesAtContentOffset:scrollView.contentOffset];
    [self p_refreshVisiblePageAppearance];
    
    if ([_delegate respondsToSelector:@selector(carousel:didScrollToPageAtIndex:)] && _currentIndex != pageIndex) {
        [_delegate carousel:self didScrollToPageAtIndex:pageIndex];
    }
    _currentIndex = pageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self p_removeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.orginPageCount > 1 && self.autoScrollInterval > 0) {
        [self p_addTimer];
        NSInteger num = floor(_scrollView.contentOffset.x / _mainPageSize.width);
        if (self.indexForTimer == num) {
            self.indexForTimer = num + 1;
        } else {
            self.indexForTimer = num;
        }
    }
}

#pragma mark - getters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

#pragma mark - dealloc
- (void)dealloc {
    [_timer invalidate];
}

@end
