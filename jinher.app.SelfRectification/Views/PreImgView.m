//
//  PreImgBtnView.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "PreImgView.h"
#import "RectiPreviewCell.h"
#import "JHLazyTableImages.h"
#import "HSProgressPopUpView.h"

@interface PreImgView ()
@property (strong, nonatomic) JHLazyTableImages *lazyImg;
@end

@implementation PreImgView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)startUploadTitle:(NSString *)title img:(UIImage *)img guideId:(NSString *)guideId InspectOptionId:(NSString *)optId order:(NSInteger) order handler:(void(^)(NSString *))hander{
    _Completehander = hander;
    [self.ibPreImgBtn setImage:img forState:UIControlStateNormal];
    RectiPreModel *model = [RectiPreModel new];
    model.image = img;
    model.hideDel = YES;
    model.title = title;
    model.order = order;
    model.guideId = guideId;
    model.optId = optId;
    self.model = model;
    [self.allUploadArr addObject:model];
    [self.lazyImg addUploadImageForCell:self withModel:model];
}

-(JHLazyTableImages *)lazyImg
{
    if (!_lazyImg) {
        _lazyImg = [JHLazyTableImages new];
    }
    return _lazyImg;
}

-(NSMutableArray<RectiPreModel *> *)allUploadArr
{
    if (!_allUploadArr) {
        _allUploadArr = [NSMutableArray new];
    }
    return _allUploadArr;
}

@end


@implementation PreImgView (MHLazyTableImages)

-(void)didLoadLazyImage:(UIImage *)theImage
{
    if (theImage!=nil) {
        [self sendSubviewToBack:self.progressView];
        [self.ibPreImgBtn setImage:theImage forState:UIControlStateNormal];
    }
}
//上传图片路径
-(void)didUploadImageUrl:(NSString *)imageUrl isUploaded:(BOOL)isuploaded
{
    if (isuploaded) {
        [self sendSubviewToBack:self.progressView];
        self.model.lazyStatus = Succeeded;
        self.model.url = imageUrl;
        _Completehander(imageUrl);
        [self.ibPreImgBtn setImage:self.model.image forState:UIControlStateNormal];
    }else{
        //重置
        self.model.lazyStatus = Fail;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"JHPatrolResources" ofType:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *shuaxin = [UIImage imageNamed:@"shuaxin" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        UIColor *grayColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
        [self.ibPreImgBtn setBackgroundColor:grayColor];
        [self.ibPreImgBtn setImage:shuaxin forState:UIControlStateNormal];
        _Completehander(imageUrl);
    }
}
//占位图
-(void)loadPlaceholderImage:(UIImage *)placeholderImage
{
    [self.ibPreImgBtn setImage:placeholderImage forState:UIControlStateNormal];
}
//上传/下载进度显示
-(void)loadingLazyImageProgress:(float)progress{
    self.model.lazyStatus = Loading;
    [self bringSubviewToFront:self.progressView];
    [self.progressView setProgress:progress animated:YES];
}
@end
