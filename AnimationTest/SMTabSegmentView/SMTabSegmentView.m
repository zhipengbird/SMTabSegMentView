//
//  SMTabSegmentView.m
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/13.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import "SMTabSegmentView.h"
#import "SMTabSegItemView.h"
#import "Masonry.h"

#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0 green:((float)((rgb & 0xFF00) >> 8)) / 255.0 blue:((float)(rgb & 0xFF)) / 255.0 alpha:1.0]

@interface SMTabSegmentView()
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIScrollView *containerView;

@property (nonatomic,strong) NSArray<NSString*> *titleArray;
@property (nonatomic,strong) NSMutableArray <SMTabSegItemView*> *tabItemsArray;

///<当前选中的索引
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation SMTabSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseConfig];
        [self createSubView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self createItemsView];
    [self addConstraintForTabItems];
    
}
- (void)baseConfig{
    self.tabItemsArray = [NSMutableArray array];
    _titleArray = @[];
    _currentIndex = 0;
    _itemSpace = 10;
    _normalFontSize = 15;
    _selectFontSize = 30;
    _normalTextColor = mRGBToColor(0xFFF700C2);
    _selectTextColor = mRGBToColor(0xFFFFD900);
    _animationInterval = 0.3;
}
- (void)createSubView{
    self.containerView = [[UIScrollView alloc] init];
    self.containerView.showsVerticalScrollIndicator = NO;
    self.containerView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc] init];
    [self.containerView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
        make.height.equalTo(self.containerView);
    }];
}

- (void)createItemsView {
    [self.tabItemsArray removeAllObjects];
    [self.titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SMTabSegItemView *itemView = [SMTabSegItemView new];
        itemView.selectFontSize = self.selectFontSize;
        itemView.normalFontSize = self.normalFontSize;
        itemView.selectTextColor = self.selectTextColor;
        itemView.normalTextColor = self.normalTextColor;
        itemView.animationInterval = self.animationInterval;
        itemView.tag = idx;
        itemView.title = obj;
        [itemView addTarget:self action:@selector(didClickTabSegItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabItemsArray addObject:itemView];
    }];
}
- (void)addConstraintForTabItems{
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    __block MASViewAttribute *leftAttribute =  self.contentView.mas_left;
    [self.tabItemsArray enumerateObjectsUsingBlock:^(SMTabSegItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
        [self addConstraintForItemView:obj leftAttribute:leftAttribute];
        leftAttribute = obj.mas_right;
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftAttribute);
    }];
}

-(void)addConstraintForItemView:(SMTabSegItemView*)item leftAttribute:(MASViewAttribute*)leftSlibling{
    CGFloat leftOffset = item.tag==0 ? 0:self.itemSpace;
    UIFont *font  = [UIFont boldSystemFontOfSize:self.normalFontSize];
    if (self.currentIndex == item.tag) {
        item.selected = YES;
        font = [UIFont boldSystemFontOfSize:self.selectFontSize];
    }
    CGSize  size  = [item.title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftSlibling).offset(leftOffset);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(size.width);
        make.height.equalTo(self.contentView);
    }];
}
-(void)didClickTabSegItem:(SMTabSegItemView*)itemView{
    [self updateUIAtIndex:itemView.tag];
    if([self.delegate respondsToSelector:@selector(segmentView:didSelectItemAtIndex:)]){
        [self.delegate segmentView:self didSelectItemAtIndex:itemView.tag];
    }
}
-(void)updateUIAtIndex:(NSInteger)index{
    if (index == self.currentIndex) {
        return;
    }
    SMTabSegItemView *itemView = [self.tabItemsArray objectAtIndex:index];
    SMTabSegItemView *lastItemView = [self.tabItemsArray objectAtIndex:self.currentIndex];
    itemView.selected = YES;
    lastItemView.selected = NO;
    CGSize currentsize = [itemView.title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.selectFontSize]} context:nil].size;
    [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(currentsize.width);
    }];
    
    currentsize = [itemView.title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.normalFontSize]} context:nil].size;
    [lastItemView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(currentsize.width);
    }];
    [UIView animateWithDuration:self.animationInterval animations:^{
        [self layoutIfNeeded];
    }];
    self.currentIndex = index;
}
#pragma mark  - setter
-(void)setTitleArray:(NSArray<NSString *> *)titleArray{
    _titleArray = titleArray;
    [self layoutIfNeeded];
}
-(void)setSelectFontSize:(CGFloat)selectFontSize{
    _selectFontSize = selectFontSize;
    [self layoutIfNeeded];
}
-(void)setNormalFontSize:(CGFloat)normalFontSize{
    _normalFontSize = normalFontSize;
    [self layoutIfNeeded];
}
-(void)setSelectTextColor:(UIColor *)selectTextColor{
    _selectTextColor = selectTextColor;
    [self layoutIfNeeded];
}
-(void)setNormalTextColor:(UIColor *)normalTextColor{
    _normalTextColor = normalTextColor;
    [self layoutIfNeeded];
}

#pragma mark  -
-(void)willScrollToViewPage:(CGFloat)index{
    
    if (index >= self.tabItemsArray.count) {
        return;
    }
    
    [self.tabItemsArray enumerateObjectsUsingBlock:^(SMTabSegItemView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != self.currentIndex){
            obj.selected = NO;
        }else{
            obj.selected = YES;
        }
    }];
    SMTabSegItemView *lastItemView = [self.tabItemsArray objectAtIndex:self.currentIndex];
    if (self.currentIndex == index) {
        lastItemView.selected= YES;
        return;
    }
    SMTabSegItemView *itemView;
    CGFloat rightScale;
    CGFloat leftScale;
    CGFloat currentfontSize =0 ;
    CGFloat previousFontSize = 0;
    if (index > self.currentIndex) {
        itemView = [self.tabItemsArray objectAtIndex:self.currentIndex+1];
        rightScale = index - self.currentIndex;
        leftScale = 1- rightScale;
        if (rightScale >= 1.0) {
            self.currentIndex = index;
            currentfontSize = self.selectFontSize;
            previousFontSize = self.normalFontSize;
            itemView.selectFontSize = self.selectFontSize;
            itemView.normalFontSize = self.normalFontSize;
            
            lastItemView.selectFontSize = self.selectFontSize;
            lastItemView.normalFontSize = self.normalFontSize;
            
            itemView.selected = YES;
            lastItemView.selected = NO;
        }else{
            currentfontSize = self.normalFontSize + (self.selectFontSize -self.normalFontSize)*rightScale;
            previousFontSize = self.normalFontSize + (self.selectFontSize - self.normalFontSize)*leftScale;
            
            [itemView updateNormalFontSize:currentfontSize];
            itemView.selectFontSize = self.selectFontSize;
            [lastItemView updateSelectFontSize:previousFontSize];
        }
        
    }else{
        leftScale = self.currentIndex - index;
        rightScale = 1- leftScale;
        itemView = [self.tabItemsArray objectAtIndex:self.currentIndex-1];
        if (leftScale >= 1.0) {
            self.currentIndex = index;
            currentfontSize = self.selectFontSize;
            previousFontSize = self.normalFontSize;
            
            itemView.selectFontSize = self.selectFontSize;
            itemView.normalFontSize = self.normalFontSize;
            
            lastItemView.selectFontSize = self.selectFontSize;
            lastItemView.normalFontSize = self.normalFontSize;
            itemView.selected = YES;
            lastItemView.selected = NO;
        }else{
            currentfontSize = self.normalFontSize + (self.selectFontSize -self.normalFontSize)*leftScale;
            previousFontSize = self.normalFontSize + (self.selectFontSize - self.normalFontSize)*rightScale;
            
            [itemView updateNormalFontSize:currentfontSize];
            itemView.selectFontSize = self.selectFontSize;
            [lastItemView updateSelectFontSize:previousFontSize];
        }
        
    }
    
    
    NSLog(@"%@,%@",@(currentfontSize),@(previousFontSize));
    
    
    CGSize currentsize = [itemView.title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:currentfontSize]} context:nil].size;
    [self.containerView scrollRectToVisible:itemView.frame animated:NO];
    
    [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(currentsize.width);
    }];
    
    currentsize = [itemView.title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:previousFontSize]} context:nil].size;
    
    [lastItemView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(currentsize.width);
    }];
    
    [UIView animateWithDuration:self.animationInterval animations:^{
        [self layoutIfNeeded];
    }];
    
}
-(void)reloadDataList:(NSArray<NSString *> *)dataList{
    self.titleArray = dataList;
    [self layoutIfNeeded];
}
-(void)defaultIndex:(NSInteger)defaultIndex{
    _currentIndex = defaultIndex;
    [self setNeedsLayout];
    if([self.delegate respondsToSelector:@selector(segmentView:didSelectItemAtIndex:)]){
        [self.delegate segmentView:self didSelectItemAtIndex:defaultIndex];
    }
}

@end
