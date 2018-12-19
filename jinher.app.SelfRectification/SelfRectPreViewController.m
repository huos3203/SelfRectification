//
//  SelfRectPreViewController.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import "SelfRectPreViewController.h"
#import "UIBezierPath+TextPaths.h"
#import "RectiPreviewCell.h"

@interface SelfRectPreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *ibBackBut;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *collDataArr;
@end

@implementation SelfRectPreViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // UIBarbuttonItem
//    FAKMaterialIcons *cogIcon = [FAKMaterialIcons flipToBackIconWithSize:20];
//    [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
//    UIImage *backImg = [cogIcon imageWithSize:CGSizeMake(20, 20)];
//    [_ibBackBut setImage:backImg forState:UIControlStateNormal];
    
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
@end
