//
//  EHPageItemsView.h
//  WFEDemo
//
//  Created by Eric Huang on 16/11/30.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EHItemViewCommon/EHTypeDefs.h>

@class EHPageItemsView;

@protocol EHPageItemsViewDelegate <NSObject>

@optional
- (void)didTapItemAtIndex:(NSInteger)index pageIndex:(NSInteger)pageIndex rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex inView:(EHPageItemsView *)view;

@end

@class EHPageLayout;

@interface EHPageItemsView : UIView

@property (nonatomic, assign) BOOL allowsAnimationWhenTap;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, copy) void (^animationBlock)(UIView *itemView, NSTimeInterval animationDuration, EHAnimationCompletionBlock animationCompletion);
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, assign) id<EHPageItemsViewDelegate> delegate;

@property (nonatomic, strong, readonly) EHPageLayout *layout;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (instancetype)initWithItems:(NSArray <UIView *> *)items itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing;

- (instancetype)initWithItems:(NSArray <UIView *> *)items layout:(EHPageLayout *)layout;

- (void)resetWithItems:(NSArray <UIView *> *)items itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing;

- (void)resetWithItems:(NSArray <UIView *> *)items layout:(EHPageLayout *)layout;

@end
