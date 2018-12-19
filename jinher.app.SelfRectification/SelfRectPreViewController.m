//
//  SelfRectPreViewController.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import "SelfRectPreViewController.h"
#import "FontAwesomeKit.h"
#import "GCDTimer.h"
#import "GCDQueue.h"
#import "UIBezierPath+TextPaths.h"
#import "RectiPreviewCell.h"

@interface SelfRectPreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *ibBackBut;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *collDataArr;
@end

@implementation SelfRectPreViewController
{
    GCDTimer *_timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // UIBarbuttonItem
    FAKMaterialIcons *cogIcon = [FAKMaterialIcons flipToBackIconWithSize:20];
    [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *backImg = [cogIcon imageWithSize:CGSizeMake(20, 20)];
    [_ibBackBut setImage:backImg forState:UIControlStateNormal];
    
//    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
//    layout.estimatedItemSize = CGSizeMake(150, 200);
    
    ///test
    for (int i = 1; i < 10; i++) {
        RectiPreModel *model = [RectiPreModel new];
        model.title = [NSString stringWithFormat:@"test %d",i];
        model.imgURL = [NSString stringWithFormat:@"https://huosan.gitee.io/img/random/material-%d.png",i];
        [self.collDataArr addObject:model];
    }
    
    
}

#pragma mark - Collection 代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collDataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RectiPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RectiPreviewCell" forIndexPath:indexPath];
    cell.model = self.collDataArr[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float _collectionCellWidth = ([UIScreen mainScreen].bounds.size.width - 40)/2;
    return CGSizeMake(_collectionCellWidth, 195);
}

#pragma mark setter/getter
-(NSMutableArray *)collDataArr
{
    if (!_collDataArr) {
        _collDataArr = [NSMutableArray new];
    }
    return _collDataArr;
}


//动画
-(void)animationView
{
    // 取得固定的icon以及设定尺寸
    FAKZocial *twitterIcon = [FAKZocial chromeIconWithSize:100];
    
    // 设定相关的属性
    [twitterIcon addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]];
    
    // 将icon转换为贝塞尔曲线
    UIBezierPath *path = [UIBezierPath pathForAttributedString:[twitterIcon attributedString]];
    
    // 创建shapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 获取path
    shapeLayer.path = path.CGPath;
    
    // 根据这个path来设定尺寸
    shapeLayer.bounds = CGPathGetBoundingBox(shapeLayer.path);
    
    // 几何反转
    shapeLayer.geometryFlipped = YES;
    
    // 一些颜色的填充
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor cyanColor].CGColor;
    
    // 设定layer位置
    shapeLayer.position = self.view.center;
    [self.view.layer addSublayer:shapeLayer];
    
    // 定时器动画
    _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_timer event:^{
        shapeLayer.strokeEnd = arc4random()%100/100.f;
    } timeInterval:NSEC_PER_SEC];
    [_timer start];
}

///渐变滚动动画
-(void)animation2
{
    // 取得固定的icon以及设定尺寸
    FAKZocial *twitterIcon = [FAKZocial chromeIconWithSize:100];
    
    // 设定相关的属性
    [twitterIcon addAttribute:NSForegroundColorAttributeName
                        value:[UIColor blackColor]];
    
    // 将icon转换为贝塞尔曲线
    UIBezierPath *path = [UIBezierPath pathForAttributedString:[twitterIcon attributedString]];
    
    // 创建shapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // 获取path
    shapeLayer.path = path.CGPath;
    
    // 根据这个path来设定尺寸
    shapeLayer.bounds = CGPathGetBoundingBox(shapeLayer.path);
    
    // 几何反转
    shapeLayer.geometryFlipped = YES;
    
    // 一些颜色的填充
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    shapeLayer.position = CGPointMake(50, 50);
    
    // 渐变颜色图层
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.bounds = CGRectMake(0, 0, 120, 120);
    colorLayer.mask = shapeLayer;
    colorLayer.colors = @[(id)[UIColor redColor].CGColor,
                          (id)[UIColor greenColor].CGColor,
                          (id)[UIColor yellowColor].CGColor];
    colorLayer.position = self.view.center;
    
    // 设定layer位置
    [self.view.layer addSublayer:colorLayer];
    
    // 旋转
//    CABasicAnimation *basicAni = \
//    [CABasicAnimationList animationWithRotationZFromValue:-2*M_PI_2 toValue:2*M_PI_2];
//    basicAni.duration = 1.0f;
//    basicAni.repeatCount = HUGE_VALF;
//    [shapeLayer addAnimation:basicAni forKey:nil];
    
    /* 旋转 */
    // 对Y轴进行旋转（指定Z轴的话，就和UIView的动画一样绕中心旋转）
//    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//    // 设定动画选项
//    basicAni.duration = 4.0f; // 持续时间
//    basicAni.repeatCount = 5; // 重复次数
//
//    // 设定旋转角度
//    basicAni.fromValue = [NSNumber numberWithFloat:-2*M_PI_2]; // 起始角度
//    basicAni.toValue = [NSNumber numberWithFloat:2*M_PI_2]; // 终止角度
//
//    // 添加动画
//    [shapeLayer addAnimation:basicAni forKey:nil];
//
//    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//    animation.fromValue=@0;
//    animation.toValue=@(M_PI*2.0);
//    animation.cumulative = YES;
//    [animation setDuration:1.0];
//    [animation setRepeatCount:HUGE_VALF];
//    [shapeLayer addAnimation:animation forKey:nil];

    
    
    // 定时器动画
    _timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [_timer event:^{
        colorLayer.colors = @[(id)[UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f
                                                  alpha:1].CGColor,
                              (id)[UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f
                                                  alpha:1].CGColor,
                              (id)[UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f
                                                  alpha:1].CGColor,
                              (id)[UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f
                                                  alpha:1].CGColor,
                              (id)[UIColor colorWithRed:arc4random()%255/255.f
                                                  green:arc4random()%255/255.f
                                                   blue:arc4random()%255/255.f
                                                  alpha:1].CGColor];
        
    } timeInterval:NSEC_PER_SEC];
    [_timer start];
}
@end
