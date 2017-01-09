//
//  EHPageItemsView.m
//  WFEDemo
//
//  Created by Eric Huang on 16/11/30.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import "EHPageItemsView.h"
#import "EHPageLayout.h"
#import <EHItemViewCommon/UIView+EHItemViewDelegate.h>

@interface EHPageItemsView () <UIScrollViewDelegate, EHItemViewDelegate>

@property (nonatomic, strong, readwrite) EHPageLayout *layout;
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation EHPageItemsView

- (instancetype)initWithItems:(NSArray<UIView *> *)items itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing {
    self = [super init];
    if (self) {
        _layout = [[EHPageLayout alloc] initWithNumberOfItems:items.count itemSize:itemSize totalWidth:totalWidth totalHeight:totalHeight insets:insets minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing];
        
        [self addScrollViewAndPageControl];
        [self addToScrollViewWithItems:items];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSArray<UIView *> *)items layout:(EHPageLayout *)layout {
    self = [super init];
    if (self) {
        _layout = layout;
        
        [self addScrollViewAndPageControl];
        [self addToScrollViewWithItems:items];
    }
    
    return self;
}

- (void)resetWithItems:(NSArray<UIView *> *)items itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.scrollView = nil;
    self.pageControl = nil;
    
    _layout = [[EHPageLayout alloc] initWithNumberOfItems:items.count itemSize:itemSize totalWidth:totalWidth totalHeight:totalHeight insets:insets minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing];
    
    [self addScrollViewAndPageControl];
    [self addToScrollViewWithItems:items];
}

- (void)resetWithItems:(NSArray<UIView *> *)items layout:(EHPageLayout *)layout {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.scrollView = nil;
    self.pageControl = nil;
    
    _layout = layout;
    
    [self addScrollViewAndPageControl];
    [self addToScrollViewWithItems:items];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger pageIndex = [self.layout pageIndexForLocation:scrollView.contentOffset];
    self.pageControl.currentPage = pageIndex;
}

#pragma mark - EHItemViewDelegate

- (void)didTapControl:(UIControl *)control inView:(UIView *)view {
    [self didTapItemAtIndex:view.tag];
}

#pragma mark - event response

- (void)didTapControl:(UIControl *)sender {
    [self didTapItemAtIndex:sender.tag];
}

- (void)didTapView:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.scrollView];
    NSInteger index = [self.layout indexForLocation:location];
    
    if (index >= 0 && index < self.layout.numberOfItems) {
        [self didTapItemAtIndex:index];
    }
}

#pragma mark - private methods

- (void)addScrollViewAndPageControl {
    // add scrollView
    [self addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                           [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                           [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                           [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
                           ]];
    
    // add pageControl
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                           [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]
                           ]];
}

- (void)addToScrollViewWithItems:(NSArray <UIView *> *)items {
    for (int i = 0; i < items.count; i++) {
        UIView *itemView = items[i];
        itemView.tag = i;
        itemView.eh_itemViewDelegate = self;
        
        if (itemView.userInteractionEnabled && [itemView respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
            UIControl *itemControl = (UIControl *)itemView;
            [itemControl addTarget:self action:@selector(didTapControl:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        itemView.frame = CGRectMake([self.layout xForIndex:i],
                                    [self.layout yForIndex:i],
                                    self.layout.itemSize.width,
                                    self.layout.itemSize.height);
        [self.scrollView addSubview:itemView];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.scrollView addGestureRecognizer:tapRecognizer];
}

- (void)didTapItemAtIndex:(NSInteger)index {
    NSInteger pageIndex = [self.layout pageIndexForIndex:index];
    NSInteger rowIndex = [self.layout rowIndexForIndex:index];
    NSInteger columnIndex = [self.layout columnIndexForIndex:index];
    
    if (!self.allowsAnimationWhenTap) {
        if ([self.delegate respondsToSelector:@selector(didTapItemAtIndex:pageIndex:rowIndex:columnIndex:inView:)]) {
            [self.delegate didTapItemAtIndex:index pageIndex:pageIndex rowIndex:rowIndex columnIndex:columnIndex inView:self];
        }
        
        return;
    }
    
    // animation!
    UIView *itemView = [self.scrollView viewWithTag:index];
    
    // if it's scrollView, find it in scrollView's subviews
    if ([self.scrollView isEqual:itemView]) {
        for (UIView *subView in self.scrollView.subviews) {
            itemView = [subView viewWithTag:index];
            
            if (itemView) {
                break;
            }
        }
    }
    
    CGFloat duration = self.animationDuration > 0 ? self.animationDuration : 0.4;
    
    if (self.animationBlock) {
        __weak typeof(self) weakSelf = self;
        
        self.animationBlock(itemView, duration, ^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            
            if (finished && [strongSelf.delegate respondsToSelector:@selector(didTapItemAtIndex:pageIndex:rowIndex:columnIndex:inView:)]) {
                [strongSelf.delegate didTapItemAtIndex:index pageIndex:pageIndex rowIndex:rowIndex columnIndex:columnIndex inView:strongSelf];
            }
        });
        
        return;
    }

    [UIView
     animateKeyframesWithDuration:duration
     delay:0
     options:UIViewKeyframeAnimationOptionCalculationModeLinear
     animations:^{
         [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
             itemView.transform = CGAffineTransformMakeScale(1.1, 1.1);
         }];
         
         [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
             itemView.transform = CGAffineTransformMakeScale(1.0, 1.0);
         }];
     } completion:^(BOOL finished) {
         if (finished && [self.delegate respondsToSelector:@selector(didTapItemAtIndex:pageIndex:rowIndex:columnIndex:inView:)]) {
             [self.delegate didTapItemAtIndex:index pageIndex:pageIndex rowIndex:rowIndex columnIndex:columnIndex inView:self];
         }
     }];
}

#pragma mark - getters & setters

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(_layout.totalWidth * _layout.numberOfPages, _layout.totalHeight);
        
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.enabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.numberOfPages = _layout.numberOfPages;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0f];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0f];
    }
    
    return _pageControl;
}

@end
