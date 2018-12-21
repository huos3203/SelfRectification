//
//  SelfRectificationController.m
//  com.jinher.SelfRectification
//
//  Created by admin on 2018/12/10.
//  Copyright © 2018年 Jinher. All rights reserved.
//

#import "SelfRectificationController.h"
#import "RectiCollCell.h"
#import "RectifTaskList.h"
//讯飞语音合成
#import "XunFeiLibrary.h"
#import "SelfRectAlertView.h"
#import "SevenImgCapture.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "FiveWatermarkView.h"

@interface SelfRectificationController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *ibTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ibCurPageNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *ibXunFeiButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//
@property (strong, nonatomic) IBOutlet FiveWatermarkView *fiveWatermarkView;

@property (strong, nonatomic) IBOutlet UIButton *ibThumImgButton;

@property (strong, nonatomic) IBOutlet  SelfRectAlertView *ibAlertView;
@property (strong, nonatomic) NSArray<ComInspectOptionGuide *> *optGuide;
@property (strong, nonatomic) ComInspectOption *curTaskOpt;
@end

@implementation SelfRectificationController
{
    NSInteger _curOptIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    _ibTitleLabel.text = _task.ClassificationName;
    _ibAlertView.hidden = YES;
    _ibThumImgButton.layer.cornerRadius = 5;
    _ibThumImgButton.layer.masksToBounds = YES;
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    // layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
    layout.estimatedItemSize = CGSizeMake(50, 30);
    
    //拍照
    _fiveWatermarkView.layer.cornerRadius = 0;
    _fiveWatermarkView.alpha = 1;
    [SevenImgCapture shared].address;
    [SevenImgCapture shared].complexMethod = ComplexMethodLowerRight;
    [SevenImgCapture shared].captureTmoutS = 1;
    [[SevenImgCapture shared] setNoHoldImageView];
    [[SevenImgCapture shared] setCaptureImageView:_fiveWatermarkView.ibFiveImgView];
    //data
    [self loadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.optGuide.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RectiCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RectiCollCell" forIndexPath:indexPath];
    ComInspectOptionGuide *model = self.optGuide[indexPath.row];
    cell.model = model;
    return cell;
}

//
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark loaddata
-(void)loadData{
    ///请求数据
    {
        [_fiveWatermarkView.ibFiveImgView sd_setImageWithURL:[NSURL URLWithString:@"https://huosan.gitee.io/img/random/material-1.png"]];
        [self nextOptItem];
    }
    
}
#pragma mark UI
-(void)nextOptGuideItem
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        ///
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        if (self.collectionView.indexPathsForSelectedItems.count > 0) {
            NSIndexPath *curIndexPath = self.collectionView.indexPathsForSelectedItems[0];
            ///完成最后一个
            if (indexPath.row + 1 == self.optGuide.count) {
                [self nextOptItem];
                return;
            }else{
                indexPath = [NSIndexPath indexPathForItem:curIndexPath.row + 1 inSection:0];
            }
        }
        ComInspectOptionGuide *model = self.optGuide[indexPath.row];
        ///更新遮罩蒙板
        [[UIImageView new] setImageWithURL:[NSURL URLWithString:model.Picture] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[SevenImgCapture shared] setMaskImage:image];
            }];
        }];
        [self.collectionView selectItemAtIndexPath:indexPath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }];
}
-(void)nextOptItem
{
    _curOptIndex++;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.ibCurPageNumLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",self->_curOptIndex,self.task.ComInspectOptionList.count];
        [self.collectionView reloadData];
    }];
    
}

#pragma mark action

- (IBAction)ibPaizhAction:(id)sender {
    
//    [[SevenImgCapture shared] waterMarkFor:self.view];
    __weak typeof(self) weakSelf = self;
    [weakSelf.ibAlertView showAlertView:NO];
    [[SevenImgCapture shared] captureImage:^(UIImage *image) {
        if (image) {
            [[SevenImgCapture shared] threeInfo];
            image = [[SevenImgCapture shared] complexText];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD showHUDText:@"正在处理五定图片..." animated:YES];
                [weakSelf.fiveWatermarkView.ibFiveImgView setImage:image];
//                [_fiveWatermarkView.ibFiveImgView sd_setImageWithURL:nil placeholderImage:image];
            }];
            weakSelf.fiveWatermarkView.uploadFinishBlock = ^(NSString *url) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD hideHUDanimated:YES];
                    [weakSelf.ibAlertView setHidden:YES];
                    //上传图片完成之后，更新title
                    [weakSelf nextOptGuideItem];
                }];
                ///TODO: 上传完成路径
                NSLog(@"图片路径：%@",url);
            };
            weakSelf.fiveWatermarkView.uploadFiveImgBlock(image);
        }
    }];
    
}
- (IBAction)ibaPreviewAction:(id)sender {
    
}
- (IBAction)ibaShowAlertViewAction:(id)sender {
    [_ibAlertView showAlertView:YES];
//    -(void)showAlertTitle:(NSString *)title msg:(NSString *)msg imgUrl:(NSString *)url
    [_ibAlertView showAlertTitle:self.curTaskOpt.Text msg:self.curTaskOpt.Remark imgUrl:self.curTaskOpt.Picture];
}

- (IBAction)ibaXunFAction:(id)sender {
    [[XunFeiLibrary shareXunFei] playWithContent:self.curTaskOpt.Remark WithWebView:nil];
}
- (IBAction)ibaBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(ComInspectOption *)curTaskOpt
{
    _curTaskOpt = _task.ComInspectOptionList[_curOptIndex];
    return _curTaskOpt;
}
-(NSArray<ComInspectOptionGuide *> *)optGuide
{
    _optGuide = self.curTaskOpt.ComInspectOptionGuideList;
    return _optGuide;
}

@end
