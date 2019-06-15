//
//  ViewController.m
//  AnimationTest
//
//  Created by yuanpinghua on 2019/6/10.
//  Copyright © 2019 yuanpinghua. All rights reserved.
//

#import "ViewController.h"
#import "LoadingView.h"
#import "CircleAnimationView.h"
#import "SMTabSegItemView.h"
#import "SMTabSegmentView.h"
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]



#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 255)

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SMTabSegmentViewDelegate>
@property (nonatomic, strong) SMTabSegmentView *segmentView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSourceList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    animationView.backgroundColor = UIColor.clearColor;
//    animationView.center = self.view.center;
//    [self.view addSubview:animationView];
//    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
//    label.text = @"7 days try";
//    [self.view addSubview:label];
//
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = label.frame;
//    [self.view.layer addSublayer:gradientLayer];
//    gradientLayer.colors = @[(id)UIColor.redColor.CGColor,(id)UIColor.yellowColor.CGColor];
//
//    gradientLayer.mask = label.layer;
//    label.frame = gradientLayer.bounds;
    
    
//    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
//    loadingView.backgroundColor = UIColor.lightGrayColor;
//    [loadingView startAnimation];
//    [self.view addSubview:loadingView];
    
    
    ///头像加载视图
    CircleAnimationView *circleAnimationView = [[CircleAnimationView alloc] initWithFrame:CGRectMake(20, 200, 100, 100)];
    [self.view addSubview:circleAnimationView];

    
   ///<分段视图示例
    self.dataSourceList = [NSMutableArray array];
    [ self.dataSourceList addObjectsFromArray:@[@"苹果",@"香蕉",@"鸭梨",@"苹果",@"香蕉",@"鸭梨",
                                            @"苹果",@"香蕉",@"鸭梨",@"苹果",@"香蕉",@"鸭梨",
                                            @"苹果",@"香蕉",@"鸭梨",@"苹果",@"香蕉",@"鸭梨",
                                            @"苹果",@"香蕉",@"鸭梨",@"苹果",@"香蕉",@"鸭梨"]];
    [self createsubView];

    SMTabSegmentView *view = [[SMTabSegmentView alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.bounds ), 50)];
    view.delegate = self;
    self.segmentView = view;
    [self.segmentView reloadDataList:self.dataSourceList];
    [self.segmentView defaultIndex:5];
    [self.view addSubview:view];

}
-(void)createsubView{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.bounds), 100) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    
    [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    [self.collectionView layoutIfNeeded];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceList.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(self.view.bounds), 100);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = randomColor;
    return cell;
}
- (IBAction)sliderValue:(UISlider*)sender {
    NSLog(@"%@",@(sender.value));
    [self.segmentView willScrollToViewPage:sender.value];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    CGFloat offset  = offsetX/scrollViewWidth;
    [self.segmentView willScrollToViewPage:offset];
    
}

-(void)segmentView:(SMTabSegmentView *)segMentView didSelectItemAtIndex:(NSInteger)index{
    
    ///如果当前的index不在屏幕上展示时，不起效果
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.collectionView scrollRectToVisible:CGRectMake(index *CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds)) animated:NO];
}
@end
