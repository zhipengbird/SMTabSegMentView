//
//  SMTabSegItemView.h
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/13.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMTabSegItemView : UIControl
@property (nonatomic, copy) NSString *title;///<标题
@property (nonatomic, assign) CGFloat selectFontSize;///<选中大小
@property (nonatomic, assign) CGFloat normalFontSize;///<正常字体大小
@property (nonatomic, strong) UIColor *selectTextColor;///<选中字体颜色
@property (nonatomic, strong) UIColor *normalTextColor;///<正常字体颜色
@property (nonatomic, assign) NSTimeInterval animationInterval;///<动画时间

-(void)updateSelectFontSize:(CGFloat)size;
-(void)updateNormalFontSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
