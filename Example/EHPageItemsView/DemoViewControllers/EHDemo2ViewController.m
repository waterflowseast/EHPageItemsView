//
//  EHDemo2ViewController.m
//  EHItemsView
//
//  Created by Eric Huang on 17/1/9.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHDemo2ViewController.h"
#import <Masonry/Masonry.h>
#import <YYCategories/UIImage+YYAdd.h>
#import <EHPageItemsView/EHPageItemsView.h>
#import "EHCenteredButton.h"

static CGFloat const kTotalHeight = 220.0f;
static CGFloat const kLabelWidth = 68.0f;
static CGFloat const kLabelHeight = 80.0f;
static CGFloat const kMinimumInteritemSpacing = 20.0f;
static CGFloat const kMinimumLineSpacing = 12.0f;
static CGFloat const kCornerRadius = 3.0f;

@interface EHDemo2ViewController () <EHPageItemsViewDelegate>

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) EHPageItemsView *pageItemsView;

@end

@implementation EHDemo2ViewController
    
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
    
#pragma mark - private methods
    
- (void)configureForNavigationBar {
    self.navigationItem.title = @"EHPageItemsView Button";
}
    
- (void)configureForViews {
    self.view.backgroundColor = [UIColor whiteColor];
}
    
- (UIColor *)randomColor {
    NSArray *colors = @[
                        [UIColor lightGrayColor],
                        [UIColor grayColor],
                        [UIColor darkGrayColor],
                        [UIColor blackColor]
                        ];
    return colors[arc4random_uniform(4)];
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
    
- (NSArray *)buttons {
    if (!_buttons) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        
        for (int i = 0; i < self.words.count; i++) {
            EHCenteredButton *button = [EHCenteredButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:self.words[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"down-arrow"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[self randomColor]] forState:UIControlStateNormal];
            button.clipsToBounds = YES;
            button.verticalSpace = 8.0f;
            button.layer.cornerRadius = kCornerRadius;
            button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            
            [mutableArray addObject:button];
        }
        
        _buttons = [mutableArray copy];
    }
    
    return _buttons;
}
    
- (EHPageItemsView *)pageItemsView {
    if (!_pageItemsView) {
        _pageItemsView = [[EHPageItemsView alloc] initWithItems:self.buttons itemSize:CGSizeMake(kLabelWidth, kLabelHeight) totalWidth:[UIScreen mainScreen].bounds.size.width totalHeight:kTotalHeight insets:UIEdgeInsetsMake(15, 15, 30, 15) minimumInteritemSpacing:kMinimumInteritemSpacing minimumLineSpacing:kMinimumLineSpacing];
        _pageItemsView.allowsAnimationWhenTap = YES;
        _pageItemsView.animationDuration = 0.4f;
        _pageItemsView.currentPageIndicatorTintColor = [UIColor redColor];
        _pageItemsView.delegate = self;
        _pageItemsView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0f];
    }
    
    return _pageItemsView;
}
    
@end
