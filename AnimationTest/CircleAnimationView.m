//
//  CircleAnimationView.m
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/12.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0 green:((float)((rgb & 0xFF00) >> 8)) / 255.0 blue:((float)(rgb & 0xFF)) / 255.0 alpha:1.0]

#define mRGBToAlpColor(rgb, alp) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0 green:((float)((rgb & 0xFF00) >> 8)) / 255.0 blue:((float)(rgb & 0xFF)) / 255.0 alpha:alp]

#import "CircleAnimationView.h"
@interface CircleAnimationView()<CAAnimationDelegate>
@property (nonatomic, strong)CAReplicatorLayer *replicatorLayer;///<layer复制层，用于复制多段点线式线条
@property (nonatomic, strong)CAShapeLayer *dotLineShapeLayer;///<点线式线条
@property (nonatomic, strong)CAShapeLayer *progressLayer;///<最外层进度条
@property (nonatomic, strong)CAGradientLayer *dotGradientLayer;///<底层渐变层
@property (nonatomic, strong)CAGradientLayer *progressGradientLayer;///<上层渐变层

@property (nonatomic, assign)NSInteger segmentCount;///<分段数量
@property (nonatomic, assign)CGFloat linewidth;///<线宽
@property (nonatomic, assign)CGFloat animationDuration;///<动画周期
@property (nonatomic, assign)CGFloat repeatCount;///<重复次数
@end

@implementation CircleAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseconfig];
        [self createSubViews];
        [self startAnimation];
    }
    return self;
}
-(void)baseconfig{
    self.segmentCount = 20;
    self.linewidth = 3;
    self.animationDuration = 6.0;
    self.repeatCount = HUGE;
}
-(void)createSubViews{
    self.dotGradientLayer = [CAGradientLayer layer];
    self.dotGradientLayer.frame = self.bounds;
    self.dotGradientLayer.colors = @[(id)mRGBToColor(0xFFF700C2).CGColor,(id)mRGBToColor(0xFFFFD900).CGColor];
    self.dotGradientLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.dotGradientLayer.startPoint = CGPointMake(0,0);
    self.dotGradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:self.dotGradientLayer];
    
    self.progressGradientLayer = [CAGradientLayer layer];
    self.progressGradientLayer.frame = self.bounds;
    self.progressGradientLayer.colors = @[(id)mRGBToColor(0xFFF700C2).CGColor,(id)mRGBToColor(0xFFFFD900).CGColor];
    self.progressGradientLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.progressGradientLayer.startPoint = CGPointMake(0, 0);
    self.progressGradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:self.progressGradientLayer];
    
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.dotGradientLayer.bounds;
    CGFloat minHeight = MAX(0,  MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)));
    minHeight -= self.linewidth*2;
    CGFloat maxRadius = minHeight / 2.0;
    CGFloat x =  (CGRectGetWidth(self.bounds) - minHeight)/ 2;
    CGFloat y =  (CGRectGetHeight(self.bounds) - minHeight)/ 2;
    shaperLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, minHeight, minHeight)
                                                  cornerRadius:maxRadius ].CGPath;
    shaperLayer.lineWidth = self.linewidth;
    shaperLayer.fillColor = UIColor.clearColor.CGColor;
    shaperLayer.strokeColor = UIColor.whiteColor.CGColor;
    shaperLayer.strokeEnd = 0;
    shaperLayer.strokeStart = 0;
    shaperLayer.lineCap = kCALineCapRound;///<线段样式
    self.progressLayer = shaperLayer;
    self.progressGradientLayer.mask = self.progressLayer;
    
    self.replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer.frame = self.bounds;
    self.dotGradientLayer.mask =  self.replicatorLayer;
    
    self.dotLineShapeLayer = [CAShapeLayer layer];
    self.dotLineShapeLayer.strokeColor = UIColor.whiteColor.CGColor;
    self.dotLineShapeLayer.fillColor = UIColor.clearColor.CGColor;
    self.dotLineShapeLayer.lineCap = kCALineCapRound;///<线段样式
    self.dotLineShapeLayer.strokeStart = 0;
    self.dotLineShapeLayer.strokeEnd = 0;
    
    [self.replicatorLayer addSublayer:self.dotLineShapeLayer];
    
    CGFloat angle = 2*M_PI /self.segmentCount;
    self.replicatorLayer.instanceCount = self.segmentCount;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.replicatorLayer.instanceDelay = 0.1;

    self.dotLineShapeLayer.bounds = CGRectMake(0, 0, maxRadius*2, maxRadius*2);
    self.dotLineShapeLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(maxRadius, maxRadius) radius:maxRadius startAngle:-angle/2 - M_PI/2 endAngle:angle/2 - M_PI/2 clockwise:YES];
    self.dotLineShapeLayer.path = path.CGPath;
    self.dotLineShapeLayer.lineWidth = self.linewidth;
    
}


-(void)startAnimation{
    
    ///<图层旋转动画
    CAKeyframeAnimation *replicatorRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    replicatorRotation.values = @[ @0.,@(M_PI * 2)];
    replicatorRotation.duration = self.animationDuration;
    replicatorRotation.fillMode = kCAFillModeForwards;
    replicatorRotation.rotationMode = kCAAnimationRotateAuto;
    replicatorRotation.calculationMode = kCAAnimationCubicPaced;
    replicatorRotation.repeatCount = self.repeatCount;
    [self.layer addAnimation:replicatorRotation forKey:@"replicatorAnimation"];

    ////<点线式线条动画
    CAKeyframeAnimation *strokenEndAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    strokenEndAnimation.values = @[@0.,@0.3,@0.6,@.1,@0.6,@0.3,@0.0,@0.0];
    strokenEndAnimation.removedOnCompletion = NO;
    strokenEndAnimation.calculationMode = kCAAnimationCubicPaced;
    strokenEndAnimation.duration = self.animationDuration;
    strokenEndAnimation.repeatCount = self.repeatCount;
    strokenEndAnimation.fillMode = kCAFillModeBackwards;
    strokenEndAnimation.delegate = self;
    strokenEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.dotLineShapeLayer addAnimation:strokenEndAnimation forKey:@"strokeEnd"];

    ///<复制层的复制延时动画
    CAKeyframeAnimation *instanceDelayAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"instanceDelay"];
    instanceDelayAnimation.values = @[ @.1,@0.05,@0.,@0.05,@0.1];
    instanceDelayAnimation.removedOnCompletion = NO;
    instanceDelayAnimation.calculationMode = kCAAnimationCubicPaced;
    instanceDelayAnimation.beginTime = CACurrentMediaTime() + self.animationDuration/2.0 ;
    instanceDelayAnimation.duration = self.animationDuration;
    instanceDelayAnimation.repeatCount = self.repeatCount;
    instanceDelayAnimation.fillMode = kCAFillModeForwards;
    instanceDelayAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.replicatorLayer addAnimation:instanceDelayAnimation forKey:@"instanceDelay"];

    ///<外层进度动画
    CAKeyframeAnimation *progressstrokenEndAnimation =  [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    progressstrokenEndAnimation.values = @[ @0.,@.5,@1.,@0.5,@0.,@0.,@0.];
    progressstrokenEndAnimation.autoreverses = NO;
    progressstrokenEndAnimation.calculationMode = kCAAnimationCubic;
    progressstrokenEndAnimation.beginTime = CACurrentMediaTime() +self.animationDuration/2.0;
    progressstrokenEndAnimation.duration = self.animationDuration;
    progressstrokenEndAnimation.repeatCount = self.repeatCount;
    progressstrokenEndAnimation.fillMode = kCAFillModeForwards;
    progressstrokenEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.progressLayer addAnimation:progressstrokenEndAnimation forKey:@"strokend"];

}

#pragma mark - CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [UIView animateWithDuration:0.2 animations:^{
            ///动画完成后，去除复制层的实例
            self.replicatorLayer.instanceCount = 0;
        }];
        NSLog(@"%s动画完成",__func__);
    }
}
@end
