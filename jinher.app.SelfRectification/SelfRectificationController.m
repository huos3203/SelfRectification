//
//  SelfRectificationController.m
//  com.jinher.SelfRectification
//
//  Created by admin on 2018/12/10.
//  Copyright © 2018年 Jinher. All rights reserved.
//

#import "SelfRectificationController.h"
#import "RectiCollCell.h"
//讯飞语音合成
#import "iFlyMSClient.h"
#import "SelfRectAlertView.h"
@interface SelfRectificationController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *ibTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ibCurPageNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *ibXunFeiButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//
@property (strong, nonatomic) IBOutlet UIView *ibContentView;

@property (strong, nonatomic) IBOutlet UIButton *ibThumImgButton;

@property (strong, nonatomic) IBOutlet  SelfRectAlertView *ibAlertView;
//data
@property (strong, nonatomic) NSMutableArray *collDataArr;

@end

@implementation SelfRectificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for (int i = 0; i < 10; i++) {
        RectCollModel *model = [RectCollModel new];
        model.title = [NSString stringWithFormat:@"left%d",i];
        [self.collDataArr addObject:model];
    }
    
    
    //UI
    _ibAlertView.hidden = YES;
    _ibThumImgButton.layer.cornerRadius = 5;
    _ibThumImgButton.layer.masksToBounds = YES;
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    // layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
    layout.estimatedItemSize = CGSizeMake(50, 30);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RectiCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RectiCollCell" forIndexPath:indexPath];
    RectCollModel *model = self.collDataArr[indexPath.row];
    cell.model = model;
    return cell;
}

//
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark action

- (IBAction)ibPaizhAction:(id)sender {
    
    
}
- (IBAction)ibaPreviewAction:(id)sender {
    
}
- (IBAction)ibaShowAlertViewAction:(id)sender {
    [_ibAlertView setHidden:NO];
}

- (IBAction)ibaXunFAction:(id)sender {
    [[iFlyMSClient shared] startSynContent:@"sfsfsf金和成功集成讯飞功能！！哈哈哈"];
}


#pragma mark set/get
-(NSMutableArray *)collDataArr
{
    if (!_collDataArr) {
        _collDataArr = [NSMutableArray new];
    }
    return _collDataArr;
}

@end
