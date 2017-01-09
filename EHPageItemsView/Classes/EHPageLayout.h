//
//  EHPageLayout.h
//  WFEDemo
//
//  Created by Eric Huang on 16/11/30.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHPageLayout : NSObject

@property (nonatomic, assign, readonly) NSInteger numberOfItems;
@property (nonatomic, assign, readonly) CGSize itemSize;

@property (nonatomic, assign, readonly) CGFloat totalWidth;
@property (nonatomic, assign, readonly) CGFloat totalHeight;
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

@property (nonatomic, assign, readonly) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign, readonly) CGFloat minimumLineSpacing;

@property (nonatomic, assign, readonly) NSInteger itemsCountPerPage;
@property (nonatomic, assign, readonly) NSInteger itemsCountPerRow;
@property (nonatomic, assign, readonly) NSInteger numberOfPages;
@property (nonatomic, assign, readonly) NSInteger numberOfRowsPerPage;

@property (nonatomic, assign, readonly) CGFloat actualInteritemSpacing;
@property (nonatomic, assign, readonly) CGFloat actualLineSpacing;

- (instancetype)initWithNumberOfItems:(NSInteger)numberOfItems itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing;

- (NSInteger)columnIndexForIndex:(NSInteger)index;
- (NSInteger)rowIndexForIndex:(NSInteger)index;
- (NSInteger)pageIndexForIndex:(NSInteger)index;

- (CGFloat)xForIndex:(NSInteger)index;
- (CGFloat)yForIndex:(NSInteger)index;

- (NSInteger)columnIndexForLocation:(CGPoint)location;
- (NSInteger)rowIndexForLocation:(CGPoint)location;
- (NSInteger)pageIndexForLocation:(CGPoint)location;
- (NSInteger)indexForLocation:(CGPoint)location;

@end
