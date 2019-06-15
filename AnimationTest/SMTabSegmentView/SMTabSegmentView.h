//
//  SMTabSegmentView.h
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/13.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SMTabSegmentView;
@protocol SMTabSegmentViewDelegate  <NSObject>

/// 分段视图选中了某段的回调
/// @param segmentView 分段视图
/// @param index 下标
-(void)segmentView:(SMTabSegmentView *)segmentView didSelectItemAtIndex:(NSInteger)index;
@end

@interface SMTabSegmentView : UIView

/// 正常字体大小
@property (nonatomic,assign) CGFloat normalFontSize;

/// 选中字体大小
@property (nonatomic,assign) CGFloat selectFontSize;

/// 正常字体颜色
@property (nonatomic,strong) UIColor *normalTextColor;

/// 选中字体颜色
@property (nonatomic,strong) UIColor *selectTextColor;

/// 每个Item间的间距
@property (nonatomic,assign) CGFloat itemSpace;

/// 动画时长
@property (nonatomic,assign) NSTimeInterval animationInterval;

/// 列表操作代理
@property (nonatomic, weak) id<SMTabSegmentViewDelegate> delegate;

///设置默认选中项
/// @param defaultIndex 选中列表下标
-(void)defaultIndex:(NSInteger)defaultIndex;

/// 用于刷新展示列表
/// @param dataList 列表数据
-(void)reloadDataList:(NSArray<NSString*>*)dataList;

/// 外层容器视图滑动的页数
/// @param index  正在滑动的页数
-(void)willScrollToViewPage:(CGFloat)index;
@end

NS_ASSUME_NONNULL_END
