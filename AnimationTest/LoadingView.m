//
//  LoadingView.m
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/10.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import "LoadingView.h"
@interface LoadingView()
@property(nonatomic, strong)UIView *round1View;
@property (nonatomic,strong)UIView *round2View;
@property (nonatomic, strong) UIView *round3View;

@property (nonatomic,strong) UIColor *round1Color;
@property (nonatomic,strong) UIColor *round2Color;
@property (nonatomic, strong) UIColor *round3Color;

@property (nonatomic,assign)CGFloat repeatTime;
@property (nonatomic,assign)CGFloat animateDuration;
@end

@implementation LoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _round1Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:1.0];
        _round2Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:0.6];
        _round3Color = [UIColor colorWithRed:206/255.0 green:7/255.0 blue:85/255.0 alpha:0.3];
        _repeatTime = 20;
        _animateDuration = 2;
        
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews{
    CGFloat circleWidth = 10;
    _round1View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
    _round2View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
    _round3View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleWidth, circleWidth)];
    [self addSubview:_round1View];
    [self addSubview:_round2View];
    [self addSubview:_round3View];
    
    _round1View.backgroundColor = _round1Color;
    _round2View.backgroundColor = _round2Color;
    _round3View.backgroundColor = _round3Color;
    
    _round1View.layer.cornerRadius = CGRectGetWidth(_round1View.bounds)/2.0;
    _round2View.layer.cornerRadius = CGRectGetWidth(_round2View.bounds)/2.0;
    _round3View.layer.cornerRadius = CGRectGetWidth(_round3View.bounds)/2.0;

    [self relayoutSubViews];
    
    }
-(void) layoutSubviews{
    [super layoutSubviews];
    [self relayoutSubViews];
}
-(void)relayoutSubViews{
    _round2View.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _round1View.center = CGPointMake(_round2View.center.x - 20, _round2View.center.y );
    _round3View.center = CGPointMake(_round2View.center.x +20, _round2View.center.y );
}
- (void)startAnimation{
    CGPoint  center1 = CGPointMake(_round1View.center.x + 10, _round2View.center.y);
    CGPoint  center2 = CGPointMake(_round2View.center.x + 10, _round2View.center.y);
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center1 radius:10 startAngle:-M_PI endAngle:0 clockwise:YES];
    [path1 appendPath:[UIBezierPath bezierPathWithArcCenter:center2 radius:10 startAngle:-M_PI endAngle:0 clockwise:NO]];
    [self animationView:_round1View animationPath:path1];

    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center1 radius:10 startAngle:0 endAngle:-M_PI clockwise:YES];
    [self animationView:_round2View animationPath:path2];
 
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:center2 radius:10 startAngle:0 endAngle:-M_PI clockwise:NO];
    [self animationView:_round3View animationPath:path3];
    
    [self animationView:_round1View fromColor:_round1Color toColor:_round3Color];
    [self animationView:_round2View fromColor:_round2Color toColor:_round1Color];
    [self animationView:_round3View fromColor:_round3Color toColor:_round2Color];

}

-(void)animationView:(UIView*)view animationPath:(UIBezierPath*)path {
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    anim.path = [path CGPath];
    anim.removedOnCompletion = false;
    anim.fillMode = kCAFillModeForwards;
    anim.calculationMode = kCAAnimationCubic;
    anim.repeatCount = HUGE;
    anim.duration = self.animateDuration;
    anim.autoreverses = NO;
//    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:anim forKey:@"animation"];
}

-(void)animationView:(UIView*)view fromColor:(UIColor*)sourceColor toColor:(UIColor*)desColor{
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.fromValue = (id)sourceColor.CGColor;
    colorAnimation.toValue = (id)desColor.CGColor;
    colorAnimation.duration = self.animateDuration;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.repeatCount = HUGE;
    [view.layer addAnimation:colorAnimation forKey:@"bgColor"];
}
@end
