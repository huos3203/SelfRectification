//
//  SelfRectificationController.m
//  com.jinher.SelfRectification
//
//  Created by admin on 2018/12/10.
//  Copyright © 2018年 Jinher. All rights reserved.
//

#import "SelfRectificationController.h"
#import "SelfRectPreViewController.h"
#import "RectiCollCell.h"
#import "RectifTaskList.h"
#import "RectiPreviewCell.h"
//讯飞语音合成
#import "XunFeiLibrary.h"
#import "SelfRectAlertView.h"
#import "SevenImgCapture.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "PreImgView.h"
#import "ReqRectifServer.h"
#import "MBProgressHUD.h"
#import "AddRectTask.h"

@interface SelfRectificationController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *ibTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ibCurPageNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *ibXunFeiButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//
@property (strong, nonatomic) IBOutlet PreImgView *preImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ibCaptureImgView;

@property (strong, nonatomic) IBOutlet  SelfRectAlertView *ibAlertView;
@property (strong, nonatomic) NSArray<ComInspectOptionGuide *> *optGuide;
@property (strong, nonatomic) ComInspectOption *curTaskOpt;
@property (strong, nonatomic) AddRectTask *addRectTask;
@end

@implementation SelfRectificationController
{
    NSInteger _curOptIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //UI
    _ibAlertView.hidden = YES;
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    // layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
    layout.estimatedItemSize = CGSizeMake(50, 30);
    
    //拍照
    [SevenImgCapture shared].address;
    [SevenImgCapture shared].complexMethod = ComplexMethodLowerRight;
    [SevenImgCapture shared].captureTmoutS = 1;
    [[SevenImgCapture shared] setNoHoldImageView];
    [[SevenImgCapture shared] setCaptureImageView:_ibCaptureImgView];
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
    [self nextOptGuideItem];
    
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
            if (curIndexPath.row + 1 == self.optGuide.count) {
                [self nextOptItem];
                return;
            }else{
                indexPath = [NSIndexPath indexPathForItem:curIndexPath.row + 1 inSection:0];
            }
        }
         self.ibCurPageNumLabel.text = [NSString stringWithFormat:@"(%ld/%ld)",indexPath.row + 1,self.optGuide.count];
        ComInspectOptionGuide *model = self.optGuide[indexPath.row];
        [self.ibCaptureImgView sd_setImageWithURL:[NSURL URLWithString:model.Picture]];
        ///更新遮罩蒙板
        [[UIImageView new] setImageWithURL:[NSURL URLWithString:model.Picture] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [[SevenImgCapture shared] setMaskImage:image];
            }];
        }];
        [self.collectionView reloadData];
        [self.collectionView selectItemAtIndexPath:indexPath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }];
}
-(void)nextOptItem
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [MBProgressHUD showHUDText:@"正在完成..." animated:YES];
        //TODO: 判断图片是否全部上传成功
        BOOL isAllUpload = true;
        NSPredicate *prePic = [NSPredicate predicateWithFormat:@"optId contains [cd] %@",self->_curTaskOpt.InspectOptionId];
        NSArray *picArray = [self.preImgView.allUploadArr filteredArrayUsingPredicate:prePic];
        for (RectiPreModel *model in picArray) {
            if (model.lazyStatus) {
                RectOptPics *pic = [RectOptPics new];
                pic.PictureSrc = model.url;
                pic.Order = model.order;
                pic.InspectOptionGuideId = model.optId;
                [self.addRectTask.option.OptionPicsList addObject:pic];
            }else{
                isAllUpload = false;
                break;
            }
        }
        if (!isAllUpload) {
            [MBProgressHUD hideHUDanimated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"部分图片上传失败！";
            [hud hide:YES afterDelay:1.f];
            return;
        }
        
        ///taskID
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"InspectOptionId contains [cd] %@",self->_curTaskOpt.InspectOptionId];
        NSArray *array = [self->_task.ComInspectOptionList filteredArrayUsingPredicate:pre];
        [self.addRectTask.optionTaskIds removeAllObjects];
        for (ComInspectOption *opt in array) {
            [self.addRectTask.optionTaskIds addObject:opt.OptionTaskId];
        }

        self.addRectTask.option.StoreId = @"451938b2-b54b-4f07-ad17-88e374bd05f2";
        self.addRectTask.option.Order = @"";
        self.addRectTask.option.InspectOptionId = self->_curTaskOpt.InspectOptionId;
        self.addRectTask.option.ClassificationId = self->_curTaskOpt.ClassificationId;
        
        [[ReqRectifServer shared] reqAddRectTask:self.addRectTask handler:^(BOOL result) {
            //
            [MBProgressHUD hideHUDanimated:YES];
            if (result) {
                self->_curTaskOpt.IsCompleted = YES;
                [self.collectionView reloadData];
                [self nextOptGuideItem];
            }else{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD hideHUDanimated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"jianchashibai！";
                    [hud hide:YES afterDelay:1.f];
                }];
            }
        }];
    }];
}

#pragma mark action

- (IBAction)ibPaizhAction:(id)sender {

    __weak typeof(self) weakSelf = self;
    [weakSelf.ibAlertView showAlertView:NO];
    [[SevenImgCapture shared] captureImage:^(UIImage *image) {
        if (image) {
            [[SevenImgCapture shared] threeInfo];
            image = [[SevenImgCapture shared] complexText];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD showHUDText:@"正在处理五定图片..." animated:YES];
            }];
            NSIndexPath *curIndexPath = weakSelf.collectionView.indexPathsForSelectedItems[0];
            ComInspectOptionGuide *model = weakSelf.optGuide[curIndexPath.row];
            [weakSelf.preImgView startUploadTitle:model.Text img:image guideId:model.Id InspectOptionId:self->_curTaskOpt.InspectOptionId order:model.Order handler:^(NSString *url) {
                ///TODO: 上传完成路径
                NSLog(@"图片路径：%@",url);
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [MBProgressHUD hideHUDanimated:YES];
                    [weakSelf.ibAlertView setHidden:YES];
                    //上传图片完成之后，更新title
                    [weakSelf nextOptGuideItem];
                }];
            }];
        }
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelfRectPreViewController"]) {
        ///
        SelfRectPreViewController *vc = segue.destinationViewController;
        vc.collDataArr = self.preImgView.allUploadArr;
    }
}
- (IBAction)ibaShowAlertViewAction:(id)sender {
    [_ibAlertView showAlertView:YES];
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
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"IsCompleted = 0  AND ComInspectOptionGuideList != nil"];
//    NSArray *array = [_task.ComInspectOptionList filteredArrayUsingPredicate:pre];
//    _curTaskOpt = array[0];
    for (ComInspectOption *opt in _task.ComInspectOptionList) {
        if (opt.IsCompleted) continue;
        if (opt.ComInspectOptionGuideList.count > 0) {
            _curTaskOpt = opt;
            _ibTitleLabel.text = _curTaskOpt.Text;
            break;
        }
    }
    return _curTaskOpt;
}
-(NSArray<ComInspectOptionGuide *> *)optGuide
{
    _optGuide = self.curTaskOpt.ComInspectOptionGuideList;
    return _optGuide;
}

-(AddRectTask *)addRectTask
{
    if (!_addRectTask) {
        _addRectTask = [AddRectTask new];
    }
    return _addRectTask;
}
@end
