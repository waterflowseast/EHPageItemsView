//
//  EHPageLayout.m
//  WFEDemo
//
//  Created by Eric Huang on 16/11/30.
//  Copyright © 2016年 Eric Huang. All rights reserved.
//

#import "EHPageLayout.h"

@interface EHPageLayout ()

@property (nonatomic, assign, readwrite) NSInteger numberOfItems;
@property (nonatomic, assign, readwrite) CGSize itemSize;

@property (nonatomic, assign, readwrite) CGFloat totalWidth;
@property (nonatomic, assign, readwrite) CGFloat totalHeight;
@property (nonatomic, assign, readwrite) UIEdgeInsets insets;

@property (nonatomic, assign, readwrite) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign, readwrite) CGFloat minimumLineSpacing;

@property (nonatomic, assign, readwrite) NSInteger itemsCountPerPage;
@property (nonatomic, assign, readwrite) NSInteger itemsCountPerRow;
@property (nonatomic, assign, readwrite) NSInteger numberOfPages;
@property (nonatomic, assign, readwrite) NSInteger numberOfRowsPerPage;

@property (nonatomic, assign, readwrite) CGFloat actualInteritemSpacing;
@property (nonatomic, assign, readwrite) CGFloat actualLineSpacing;

@end

@implementation EHPageLayout

- (instancetype)initWithNumberOfItems:(NSInteger)numberOfItems itemSize:(CGSize)itemSize totalWidth:(CGFloat)totalWidth totalHeight:(CGFloat)totalHeight insets:(UIEdgeInsets)insets minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing minimumLineSpacing:(CGFloat)minimumLineSpacing {
    self = [super init];
    if (self) {
        _numberOfItems = numberOfItems;
        _itemSize = itemSize;
        _totalWidth = totalWidth;
        _totalHeight = totalHeight;
        _insets = insets;
        _minimumInteritemSpacing = minimumInteritemSpacing;
        _minimumLineSpacing = minimumLineSpacing;
        
        [self calculateValues];
    }
    
    return self;
}

- (NSInteger)columnIndexForIndex:(NSInteger)index {
    if (self.numberOfPages == 0) {
        return 0;
    }

    return (index % self.itemsCountPerPage) % self.itemsCountPerRow;
}

- (NSInteger)rowIndexForIndex:(NSInteger)index {
    if (self.numberOfPages == 0) {
        return 0;
    }

    return (index % self.itemsCountPerPage) / self.itemsCountPerRow;
}

- (NSInteger)pageIndexForIndex:(NSInteger)index {
    if (self.numberOfPages == 0) {
        return 0;
    }

    return index / self.itemsCountPerPage;
}

- (CGFloat)xForIndex:(NSInteger)index {
    NSInteger columnIndex = [self columnIndexForIndex:index];
    NSInteger pageIndex = [self pageIndexForIndex:index];
    return self.totalWidth * pageIndex + self.insets.left + columnIndex * (self.itemSize.width + self.actualInteritemSpacing);
}

- (CGFloat)yForIndex:(NSInteger)index {
    NSInteger rowIndex = [self rowIndexForIndex:index];
    return self.insets.top + rowIndex * (self.itemSize.height + self.actualLineSpacing);
}

- (NSInteger)columnIndexForLocation:(CGPoint)location {
    CGFloat x = location.x - [self pageIndexForLocation:location] * self.totalWidth;

    if (x <= self.insets.left) {
        return -1; // 落在第一个item的左边界之内
    }
    
    if (x >= self.insets.left + self.itemsCountPerRow * self.itemSize.width + (self.itemsCountPerRow - 1) * self.actualInteritemSpacing) {
        return -1; // 落在最后一个item的右边界之外
    }
    
    CGFloat tempWidth = x - self.insets.left;
    NSInteger count = (int)floorf(tempWidth / (self.itemSize.width + self.actualInteritemSpacing));
    CGFloat remainingWidth = tempWidth - count * (self.itemSize.width + self.actualInteritemSpacing);
    
    if (remainingWidth >= self.itemSize.width) {
        return -1; // 落在空隙之间
    }
    
    return count;
}

- (NSInteger)rowIndexForLocation:(CGPoint)location {
    if (location.y <= self.insets.top) {
        return -1; // 落在第一个item的上边界之内
    }
    
    if (location.y >= self.insets.top + self.numberOfRowsPerPage * self.itemSize.height + (self.numberOfRowsPerPage - 1) * self.actualLineSpacing) {
        return -1; // 落在最后一个item的下边界之外
    }
    
    CGFloat tempHeight = location.y - self.insets.top;
    NSInteger count = (int)floorf(tempHeight / (self.itemSize.height + self.actualLineSpacing));
    CGFloat remainingHeight = tempHeight - count * (self.itemSize.height + self.actualLineSpacing);
    
    if (remainingHeight >= self.itemSize.height) {
        return -1; // 落在空隙之间
    }
    
    return count;
}

- (NSInteger)pageIndexForLocation:(CGPoint)location {
    return (int)floorf(location.x / self.totalWidth);
}

- (NSInteger)indexForLocation:(CGPoint)location {
    if (self.numberOfPages == 0) {
        return -1;
    }

    NSInteger columnIndex = [self columnIndexForLocation:location];
    NSInteger rowIndex = [self rowIndexForLocation:location];
    
    if (columnIndex < 0 || rowIndex < 0) {
        return -1;
    }
    
    NSInteger pageIndex = [self pageIndexForLocation:location];
    NSInteger index = pageIndex * self.itemsCountPerPage + rowIndex * self.itemsCountPerRow + columnIndex;
    
    if (index < self.numberOfItems) {
        return index;
    } else {
        return -1;
    }
}

#pragma mark - private methods

- (void)calculateValues {
    // calculate itemsCountPerRow
    
    // self.insets.left + n * self.itemSize.width + (n - 1) * self.minimumInteritemSpacing + self.insets.right < self.totalWidth
    // n * (self.itemSize.width + self.minimumInteritemSpacing) < self.totalWidth + self.minimumInteritemSpacing - self.insets.left - self.insets.right
    CGFloat widthPerItem = _itemSize.width + _minimumInteritemSpacing;
    if (widthPerItem == 0) {
        _itemsCountPerRow = 0;
    } else {
        CGFloat remainingWidth = _totalWidth + _minimumInteritemSpacing - _insets.left - _insets.right;
        _itemsCountPerRow = (int)floorf(remainingWidth / widthPerItem);
    }
    
    // calculate numberOfRowsPerPage
    
    // self.insets.top + n * self.itemSize.height + (n - 1) * self.minimumLineSpacing + self.insets.bottom < self.totalHeight
    // n * (self.itemSize.height + self.minimumLineSpacing) < self.totalHeight + self.minimumLineSpacing - self.insets.top - self.insets.bottom
    CGFloat heightPerItem = _itemSize.height + _minimumLineSpacing;
    if (heightPerItem == 0) {
        _numberOfRowsPerPage = 0;
    } else {
        CGFloat remainingHeight = _totalHeight + _minimumLineSpacing - _insets.top - _insets.bottom;
        _numberOfRowsPerPage = (int)floorf(remainingHeight / heightPerItem);
    }
    
    // calculate itemsCountPerPage
    _itemsCountPerPage = _itemsCountPerRow * _numberOfRowsPerPage;
    
    // calculate numberOfPages
    if (_itemsCountPerPage == 0) {
        _numberOfPages = 0;
    } else {
        NSInteger quotient = _numberOfItems / _itemsCountPerPage;
        NSInteger remainder = _numberOfItems % _itemsCountPerPage;
        
        _numberOfPages = remainder == 0 ? quotient : quotient + 1;
    }
    
    // calculate actualInteritemSpacing
    if (_itemsCountPerRow > 1) {
        CGFloat totalHSpacing = _totalWidth - _insets.left - _insets.right - _itemsCountPerRow * _itemSize.width;
        _actualInteritemSpacing = totalHSpacing / (_itemsCountPerRow - 1);
    } else {
        _actualInteritemSpacing = 0;
    }
    
    // calculate actualLineSpacing
    if (_numberOfRowsPerPage > 1) {
        CGFloat totalVSpacing = _totalHeight - _insets.top - _insets.bottom - _numberOfRowsPerPage * _itemSize.height;
        _actualLineSpacing = totalVSpacing / (_numberOfRowsPerPage - 1);
    } else {
        _actualLineSpacing = 0;
    }
}

@end
