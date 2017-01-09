//
//  EHDemo4ViewController.m
//  EHItemsView
//
//  Created by Eric Huang on 17/1/9.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHDemo4ViewController.h"
#import <Masonry/Masonry.h>
#import <EHPageItemsView/EHPageItemsSelectionView.h>
#import <EHItemViewCommon/EHTypeDefs.h>
#import "WFELabel.h"

static CGFloat const kTotalHeight = 120.0f;
static CGFloat const kLabelWidth = 68.0f;
static CGFloat const kLabelHeight = 30.0f;
static CGFloat const kMinimumInteritemSpacing = 20.0f;
static CGFloat const kMinimumLineSpacing = 12.0f;

@interface EHDemo4ViewController () <EHPageItemsViewDelegate, EHItemViewSelectionDelegate>

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) EHPageItemsSelectionView *pageItemsView;

@end

@implementation EHDemo4ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configureForNavigationBar];
    [self configureForViews];
    
    [self.view addSubview:self.pageItemsView];
    [self.pageItemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(kTotalHeight);
    }];
}
    
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
    
#pragma mark - EHPageItemsViewDelegate
    
- (void)didTapItemAtIndex:(NSInteger)index pageIndex:(NSInteger)pageIndex rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex inView:(EHPageItemsView *)view {
    NSLog(@"===> index: %ld, pageIndex: %ld, rowIndex: %ld, columnIndex: %ld, word: %@", index, pageIndex, rowIndex, columnIndex, self.words[index]);
}
    
#pragma mark - EHItemViewSelectionDelegate
    
- (void)didTapExceedingLimitInView:(UIView *)view maxSelectionsAllowed:(NSUInteger)maxSelectionsAllowed {
    NSLog(@"===> exceeding max: %ld", (long)maxSelectionsAllowed);
}
    
#pragma mark - private methods
    
- (void)configureForNavigationBar {
    self.navigationItem.title = @"EHPageItemsSelectionView Single Selection Custom Animation";
}
    
- (void)configureForViews {
    self.view.backgroundColor = [UIColor whiteColor];
}
    
#pragma mark - getters & setters
    
- (NSArray *)words {
    if (!_words) {
        _words = @[
                   @"照片", @"拍摄", @"小视频", @"视频聊天",
                   @"红包", @"转账", @"位置", @"收藏",
                   @"个人名片", @"语音输入", @"卡券"
                   ];
    }
    
    return _words;
}
    
- (NSArray *)labels {
    if (!_labels) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (int i = 0; i < self.words.count; i++) {
            WFELabel *label = [[WFELabel alloc] initWithText:self.words[i]];
            
            [mutableArray addObject:label];
        }
        
        _labels = [mutableArray copy];
    }
    
    return _labels;
}
    
- (EHPageItemsSelectionView *)pageItemsView {
    if (!_pageItemsView) {
        _pageItemsView = [[EHPageItemsSelectionView alloc] initWithItems:self.labels itemSize:CGSizeMake(kLabelWidth, kLabelHeight) totalWidth:[UIScreen mainScreen].bounds.size.width totalHeight:kTotalHeight insets:UIEdgeInsetsMake(15, 15, 30, 15) minimumInteritemSpacing:kMinimumInteritemSpacing minimumLineSpacing:kMinimumLineSpacing];
        _pageItemsView.allowsAnimationWhenTap = YES;
        _pageItemsView.animationDuration = 0.4f;
        _pageItemsView.allowsToCancelWhenSingleSelection = YES;
        
        _pageItemsView.animationBlock = ^(UIView *itemView, NSTimeInterval animationDuration, EHAnimationCompletionBlock animationCompletion) {
            [UIView
             animateKeyframesWithDuration:animationDuration
             delay:0
             options:UIViewKeyframeAnimationOptionCalculationModeLinear
             animations:^{
                 [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                     itemView.transform = CGAffineTransformMakeTranslation(10.0f, 0);
                 }];
                 
                 [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.4 animations:^{
                     itemView.transform = CGAffineTransformMakeTranslation(-10.0f, 0);
                 }];
                 
                 [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
                     itemView.transform = CGAffineTransformMakeTranslation(0, 0);
                 }];
             } completion:animationCompletion];
        };
        
        _pageItemsView.currentPageIndicatorTintColor = [UIColor redColor];
        _pageItemsView.delegate = self;
        _pageItemsView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0f];
    }
    
    return _pageItemsView;
}
    
@end
