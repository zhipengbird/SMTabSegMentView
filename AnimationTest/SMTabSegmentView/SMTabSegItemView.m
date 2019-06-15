//
//  SMTabSegItemView.m
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/13.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import "SMTabSegItemView.h"
#import "Masonry.h"
@interface SMTabSegItemView ()
@property (nonatomic, strong) UIImage *selectTabImage;///<选中状态的图片
@property (nonatomic, strong) UIImage *normalTabImage;///<正常状态下的图片
@property (nonatomic, strong) UIImageView *titleImageView;////<图片视图
@end

@implementation SMTabSegItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectFontSize = 30;
        self.normalFontSize = 15;
        self.selectTextColor = UIColor.redColor;
        self.normalTextColor = UIColor.blackColor;
        self.animationInterval = 0.3;
        [self createTabImageView];
        self.titleImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}
-(void)createTabImageView{
    self.titleImageView = [UIImageView new];
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.titleImageView];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.normalFontSize + 5);
        make.bottom.equalTo(self).offset(-12);
    }];
}
-(void)setNormalFontSize:(CGFloat)normalFontSize{
    _normalFontSize = normalFontSize;
    [self refreshImage];
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(normalFontSize+5);
    }];
}
-(void)setSelectFontSize:(CGFloat)selectFontSize{
    _selectFontSize = selectFontSize;
    [self refreshImage];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.normalTabImage = [self drawImageWithTitle:title textColor:self.normalTextColor textfont:[UIFont boldSystemFontOfSize:self.normalFontSize]];
    self.selectTabImage = [self drawImageWithTitle:title textColor:self.selectTextColor textfont:[UIFont boldSystemFontOfSize:self.selectFontSize]];
    self.titleImageView.image = self.normalTabImage;
}
-(void)refreshImage{
    if (_title) {
        self.normalTabImage = [self drawImageWithTitle:self.title textColor:self.normalTextColor textfont:[UIFont boldSystemFontOfSize:self.normalFontSize]];
        self.selectTabImage = [self drawImageWithTitle:self.title textColor:self.selectTextColor textfont:[UIFont boldSystemFontOfSize:self.selectFontSize]];
    }
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self updateTitleImage:self.selectTabImage height:self.selectFontSize bottom:-10];
    }else{
        [self updateTitleImage:self.normalTabImage height:self.normalFontSize bottom:-12];
    }
    if (selected != self.isSelected) {
        [UIView animateWithDuration:self.animationInterval animations:^{
            [self layoutIfNeeded];
        }];
    }
    [super setSelected:selected];
}

-(void)updateTitleImage:(UIImage*)image height:(CGFloat)height bottom:(CGFloat)bottom{
    self.titleImageView.image = image;
    [self.titleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height+5);
        make.bottom.equalTo(self.mas_bottom).offset(bottom);
    }];
}
- (UIImage*)drawImageWithTitle:(NSString *)title textColor:(UIColor*)textColor textfont:(UIFont *)font{
    CGSize size = [title boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.lineSpacing = 0;
    style.paragraphSpacing = 2;
    NSDictionary *attribute =@{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:textColor,
                               NSBackgroundColorAttributeName:UIColor.clearColor,
                               NSParagraphStyleAttributeName:style
                               };
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [title drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attribute];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)updateSelectFontSize:(CGFloat)size{
    CGFloat percent =1 - (size - self.normalFontSize)/(self.selectFontSize - self.normalFontSize);
    UIColor *color = [self startColor:self.selectTextColor gradientToDesColor:self.normalTextColor progress:percent];
    UIImage *image = [self drawImageWithTitle:self.title textColor:color textfont:[UIFont boldSystemFontOfSize:size]];
    [self updateTitleImage:image height:size bottom:-11];
}

-(void)updateNormalFontSize:(CGFloat)size{
    CGFloat percent = (size - self.normalFontSize)/(self.selectFontSize - self.normalFontSize);
    UIColor *color = [self startColor:self.normalTextColor gradientToDesColor:self.selectTextColor progress:percent];
    UIImage *image = [self drawImageWithTitle:self.title textColor:color textfont:[UIFont boldSystemFontOfSize:size]];
    [self updateTitleImage:image height:size bottom:-11];
}


-(UIColor *)startColor:(UIColor*)sourceColor gradientToDesColor:(UIColor*) desColor progress:(CGFloat)percent{
    
    CGFloat red1,red2,green1,green2,blue1,blue2,alpha1,alpha2;
    [sourceColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [desColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat red = red1+ percent*(red2 - red1);
    CGFloat green = green1+ percent*(green2 - green1);
    CGFloat blue = blue1+  percent*(blue2 - blue1);
    CGFloat alpha = alpha1+ percent*(alpha2 - alpha1);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
