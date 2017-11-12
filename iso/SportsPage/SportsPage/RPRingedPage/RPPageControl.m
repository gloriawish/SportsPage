//
//  RPPageControl.m
//  RPRingedPages
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 Ding. All rights reserved.
//

#import "RPPageControl.h"

static const CGFloat defaultIndicatorWidth = 6.0f;
static const CGFloat defaultIndicatorMargin = 10.0f;
static const CGFloat defaultMinHeight = 36.0f;

@interface RPPageControl ()
@property (nonatomic, strong) UIPageControl *systemPageControl;
@end

@implementation RPPageControl {
@private
    NSInteger			_displayedPage;
    CGFloat				_measuredIndicatorWidth;
    CGFloat				_measuredIndicatorHeight;
}

- (void)p_initialize {
    _numberOfPages = 0;

    _indicatorDiameter = defaultIndicatorWidth;
    self.indicatorMargin = defaultIndicatorMargin;
    self.minHeight = defaultMinHeight;
    
    _alignment = RPPageControlAlignmentCenter;
    _verticalAlignment = RPPageControlVerticalAlignmentMiddle;
    _indicatorTintColor = [UIColor lightGrayColor];
    _currentIndicatorTintColor = [UIColor blueColor];
    
    self.backgroundColor = [UIColor clearColor];
    self.isAccessibilityElement = YES;
    self.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently;
    self.contentMode = UIViewContentModeRedraw;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    [self p_initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (nil == self) {
        return nil;
    }
    [self p_initialize];
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self p_renderPages:context rect:rect];
}

- (void)p_renderPages:(CGContextRef)context rect:(CGRect)rect {
    
    CGFloat left = [self p_leftOffset];
    
    CGFloat xOffset = left;
    CGFloat yOffset = 0.0f;
    UIImage *image = nil;
    
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        
        if (i == _displayedPage) {
            image = _currentPageIndicatorImage;
        } else {
            image = _pageIndicatorImage;
        }
        CGRect indicatorRect;
        if (image) {
            yOffset = [self p_topOffsetForHeight:image.size.height rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - image.size.width) * 0.5);
            [image drawAtPoint:CGPointMake(centeredXOffset, yOffset)];
            indicatorRect = CGRectMake(centeredXOffset, yOffset, image.size.width, image.size.height);
        } else {
            
            /** dont't work, why? In the Swift version (https://github.com/DingHub/RingedPages), works */
            /** so I have to add systemPageControl. See line 111 - 121*/
            /*
            yOffset = [self p_topOffsetForHeight:_indicatorDiameter rect:rect];
            CGFloat centeredXOffset = xOffset + floorf((_measuredIndicatorWidth - _indicatorDiameter) * 0.5);
            indicatorRect = CGRectMake(centeredXOffset, yOffset, _indicatorDiameter, _indicatorDiameter);
            if (i == _displayedPage) {
                CGContextSetFillColor(context, CGColorGetComponents(_currentIndicatorTintColor.CGColor));
            } else {
                CGContextSetFillColor(context, CGColorGetComponents(_indicatorTintColor.CGColor));
            }
            CGContextFillEllipseInRect(context, indicatorRect);
             */
        }
        xOffset += _measuredIndicatorWidth + _indicatorMargin;
    }
    [self layoutIfNeeded];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_currentPageIndicatorImage && !_pageIndicatorImage) {
        [self addSubview:self.systemPageControl];
        self.systemPageControl.frame = self.bounds ;
        self.systemPageControl.pageIndicatorTintColor = self.indicatorTintColor;
        self.systemPageControl.currentPageIndicatorTintColor = self.currentIndicatorTintColor;
    } else {
        [self.systemPageControl removeFromSuperview];
    }
}

- (CGFloat)p_leftOffset {
    CGRect rect = self.bounds;
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = 0.0f;
    switch (_alignment) {
        case RPPageControlAlignmentCenter:
            left = ceilf(CGRectGetMidX(rect) - (size.width * 0.5));
            break;
        case RPPageControlAlignmentRight:
            left = CGRectGetMaxX(rect) - size.width;
            break;
        default:
            break;
    }
    
    return left;
}

- (CGFloat)p_topOffsetForHeight:(CGFloat)height rect:(CGRect)rect {
    CGFloat top = 0.0f;
    switch (_verticalAlignment) {
        case RPPageControlVerticalAlignmentMiddle:
            top = CGRectGetMidY(rect) - (height * 0.5);
            break;
        case RPPageControlVerticalAlignmentBottom:
            top = CGRectGetMaxY(rect) - height;
            break;
        default:
            break;
    }
    return top;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    CGFloat marginSpace = MAX(0, pageCount - 1) * _indicatorMargin;
    CGFloat indicatorSpace = pageCount * _measuredIndicatorWidth;
    CGSize size = CGSizeMake(marginSpace + indicatorSpace, _measuredIndicatorHeight);
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [self sizeForNumberOfPages:self.numberOfPages];
    sizeThatFits.height = MAX(sizeThatFits.height, _minHeight);
    return sizeThatFits;
}

#pragma mark -
- (void)p_updateMeasuredIndicatorSizes {
    _measuredIndicatorWidth = _indicatorDiameter;
    _measuredIndicatorHeight = _indicatorDiameter;
    
    if ( self.pageIndicatorImage && self.currentPageIndicatorImage ) {
        _measuredIndicatorWidth = 0;
        _measuredIndicatorHeight = 0;
    }
    
    if (self.pageIndicatorImage) {
        [self p_updateMeasuredIndicatorSizeWithSize:self.pageIndicatorImage.size];
    }
    
    if (self.currentPageIndicatorImage) {
        [self p_updateMeasuredIndicatorSizeWithSize:self.currentPageIndicatorImage.size];
    }
    
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
}
- (void)p_updateMeasuredIndicatorSizeWithSize:(CGSize)size {
    _measuredIndicatorWidth = MAX(_measuredIndicatorWidth, size.width);
    _measuredIndicatorHeight = MAX(_measuredIndicatorHeight, size.height);
}


#pragma mark - Tap Gesture
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
    CGFloat left = [self p_leftOffset];
    CGFloat middle = left + (size.width * 0.5);
    if (point.x < middle) {
        [self setCurrentIndex:self.currentIndex - 1 sendEvent:YES canDefer:YES];
    } else {
        [self setCurrentIndex:self.currentIndex + 1 sendEvent:YES canDefer:YES];
    }
    
}

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter {
    if (indicatorDiameter == _indicatorDiameter) {
        return;
    }
    if (_minHeight < indicatorDiameter) {
        self.minHeight = indicatorDiameter;
    }
    [self p_updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin {
    if (indicatorMargin == _indicatorMargin) {
        return;
    }
    _indicatorMargin = indicatorMargin;
    [self setNeedsDisplay];
}

- (void)setMinHeight:(CGFloat)minHeight {
    if (minHeight == _minHeight) {
        return;
    }
    if (minHeight < _indicatorDiameter) {
        _indicatorDiameter = minHeight;
    }
    _minHeight = minHeight;
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages == _numberOfPages) {
        return;
    }
    self.systemPageControl.numberOfPages = numberOfPages;
    if (numberOfPages > 0) {
        self.systemPageControl.currentPage = 0;
    }
    _numberOfPages = MAX(0, numberOfPages);
    if ([self respondsToSelector:@selector(invalidateIntrinsicContentSize)]) {
        [self invalidateIntrinsicContentSize];
    }
    [self updateAccessibilityValue];
    [self setNeedsDisplay];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    [self setCurrentIndex:currentIndex sendEvent:NO canDefer:NO];
}

- (void)setCurrentIndex:(NSInteger)currentIndex sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer {
    _currentIndex = MIN(MAX(0, currentIndex), _numberOfPages - 1);
    self.systemPageControl.currentPage = self.currentIndex;
    [self updateAccessibilityValue];
    if (!defer) {
        _displayedPage = _currentIndex;
        [self setNeedsDisplay];
    }
    if (sendEvent) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    if ([currentPageIndicatorImage isEqual:_currentPageIndicatorImage]) {
        return;
    }
    _currentPageIndicatorImage = currentPageIndicatorImage;
    [self p_updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    if ([pageIndicatorImage isEqual:_pageIndicatorImage]) {
        return;
    }
    _pageIndicatorImage = pageIndicatorImage;
    [self p_updateMeasuredIndicatorSizes];
    [self setNeedsDisplay];
}


- (UIPageControl *)systemPageControl {
    if (_systemPageControl == nil) {
        _systemPageControl = [UIPageControl new];
        _systemPageControl.userInteractionEnabled = NO;
    }
    return _systemPageControl;
}


#pragma mark - UIAccessibility
- (void)updateAccessibilityValue {
    self.accessibilityValue = self.systemPageControl.accessibilityValue;
}
@end

