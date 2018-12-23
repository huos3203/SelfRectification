//
//  JHIdentifyCapture.m
//  JHUniversalApp
//
//  Created by jinher on 2018/7/23.
//  Copyright © 2018年  William Sterling. All rights reserved.
//

#import "JHIdentifyCapture.h"
#import "JHAutomaticCapture.h"
/*
// 拍照方式
typedef NS_OPTIONS(NSUInteger, CaptureOptions) {
    CaptureOptionPicture = 1 << 0,  // 普通拍照
    CaptureOptionCamera = 1 << 1,   // 前后摄像
};

ComplexMethodNoSynthetic,   // 不合成
*/

@interface JHIdentifyText : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attrs;
@property (nonatomic, assign) CGPoint position;
@end

@implementation JHIdentifyText
@end

@interface JHIdentifyCapture() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) JHAutomaticCapture *autoCapture;
//@property (nonatomic, strong) NSMutableArray *originImageArr;
@property (nonatomic, strong) NSMutableArray *identifyTextArr;
@property (strong, nonatomic) void (^handlerImage)(UIImage *image);
@end

@implementation JHIdentifyCapture

- (void)dealloc {
    //NSLog(@"JHIdentifyCapture dealloc");
    [self cancelCapture];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoCapture = [[JHAutomaticCapture alloc] init];
        self.identifyTextArr = [[NSMutableArray alloc] init];
        self.leftRightMargin = -30;//30;
        self.topBottomMargin = -40;//20;
    }
    return self;
}
/*
- (int)addText:text withAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs AndPosition:(CGPoint)pos {
    JHIdentifyText *obj = [[JHIdentifyText alloc] init];
    obj.text = text;
    obj.attrs = attrs;
    obj.position = pos;
    [self.identifyTextArr addObject:obj];
    return 0;
}
*/
- (int)addText:(NSString *)text WithFont:(UIFont *)font AndAlign:(IdentifyAlign)align {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    CGSize imageSize = self.resultImage.size;
    CGFloat lrMargin = [self getLeftRightMargin];
    CGFloat tbMargin = [self getTopBottomMargin];
    
    CGPoint pos;
    if (align == IdentifyAlignTopLeft) {
        pos.x = lrMargin;
        pos.y = tbMargin;
    } else if (align == IdentifyAlignTopRight) {
        pos.x = imageSize.width - lrMargin - textSize.width;
        pos.y = tbMargin;
    } else if (align == IdentifyAlignBottomLeft) {
        pos.x = lrMargin;
        pos.y = imageSize.height - tbMargin - textSize.height;
    } else {
        pos.x = imageSize.width - lrMargin - textSize.width;
        pos.y = imageSize.height - tbMargin - textSize.height;
    }
    return [self addText:text WithFont:font AndPosition:pos];
}

- (int)addText:(NSString *)text Text2:(NSString *)text2 WithFont:(UIFont *)font AndAlign:(IdentifyAlign)align {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGSize textSize2 = [text2 boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    CGSize imageSize = self.resultImage.size;
    CGFloat lrMargin = [self getLeftRightMargin];
    CGFloat tbMargin = [self getTopBottomMargin];
    
    CGPoint pos;
    if (align == IdentifyAlignTopLeft) {
        pos.x = lrMargin;
        pos.y = tbMargin;
    } else if (align == IdentifyAlignTopRight) {
        pos.x = imageSize.width - lrMargin - textSize.width;
        pos.y = tbMargin;
    } else if (align == IdentifyAlignBottomLeft) {
        pos.x = lrMargin;
        pos.y = imageSize.height - tbMargin - textSize.height;
    } else {
        pos.x = imageSize.width - lrMargin - textSize.width;
        pos.y = imageSize.height - tbMargin - textSize.height;
    }
    int ret = [self addText:text WithFont:font AndPosition:pos];

    if (align == IdentifyAlignTopLeft) {
        pos.y += textSize.height + tbMargin / 2;
        [self addText:text2 WithFont:font AndPosition:pos];
    } else if (align == IdentifyAlignTopRight) {
        pos.x = imageSize.width - lrMargin - textSize2.width;
        pos.y += textSize.height + tbMargin / 2;
        [self addText:text2 WithFont:font AndPosition:pos];
    } else if (align == IdentifyAlignBottomLeft) {
        pos.y -= textSize2.height + tbMargin / 2;
        [self addText:text2 WithFont:font AndPosition:pos];
    } else {
        pos.x = imageSize.width - lrMargin - textSize2.width;
        pos.y -= textSize2.height + tbMargin / 2;
        [self addText:text2 WithFont:font AndPosition:pos];
    }
    
    return ret;
}

- (int)addText:(NSString *)text WithFont:(UIFont *)font AndPosition:(CGPoint)pos {
    if ([text length] == 0) {
        return 0;
    }
    JHIdentifyText *obj = [[JHIdentifyText alloc] init];
    obj.text = text;
    obj.attrs = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    obj.position = pos;
    [self.identifyTextArr addObject:obj];
    return 0;
}

- (UIImage *)complexText {
    UIImage *image = self.resultImage;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    //做CTM变换
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    for (JHIdentifyText *obj in self.identifyTextArr) {
        NSString *text = obj.text;
        [text drawAtPoint:obj.position withAttributes:obj.attrs];
    }
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
/*
// 捕获图像,返回合成后的图像
- (int)captureImage:(CaptureOptions)options completion:(void(^)(UIImage *complexImage))handler {
    self.handlerImage = handler;
    if (options & CaptureOptionPicture) {   // 拍照
        [self capturePicture];
    } else if (options & CaptureOptionCamera) { // 摄像
        [self captureCamera];
    }
    
    return 0;
}
*/
- (int)captureImage:(void(^)(UIImage *image))handler {
    [self.identifyTextArr removeAllObjects];
    self.handlerImage = handler;
    if (self.complexMethod == ComplexMethodLowerRight) {    // 先拍景再取人像
        [self capturePicture];
    } else if (self.complexMethod == ComplexMethodLeftRight) { // 先取人像再摄景
        [self captureCamera];
    }
    return 0;
}

// 取消抓拍
- (int)cancelCapture {
    [self.autoCapture disposeCamare];
    return 0;
}

// 是否正在抓拍
- (BOOL)isCapturing {
    return [self.autoCapture isCamaring];
}

- (int)capturePicture {
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = NO;//YES;
    [self.viewController presentViewController:picker animated:YES completion:^{
    }];
    return 0;
}

- (int)captureCamera {
    self.autoCapture.secretlyCamera = self.secretlyCamera;
    self.autoCapture.captureTmoutS = self.captureTmoutS;
    [self.autoCapture showCameraView:YES completion:^(UIImage *image1, UIImage *image2) {
        self.isCaptureTmout = self.autoCapture.isCaptureTmout;
        [self returnImage:image1 Image2:image2];
    }];
    return 0;
}

- (void)returnImage:(UIImage *)image1 Image2:(UIImage *)image2 {
    UIImage *image = [self complexImage:image1 Image2:image2];
    self.resultImage = image;
    self.handlerImage(image);
}

- (UIImage *)complexImage:(UIImage *)image1 Image2:(UIImage *)image2 {
    UIImage *resultImg = image1;
    if (self.complexMethod == ComplexMethodLowerRight) {
        resultImg = [self lowerRightImage:image1 Image2:image2];
    } else if (self.complexMethod == ComplexMethodLeftRight) {
        resultImg = [self leftRightImage:image1 Image2:image2];
    } else {
    }
    return resultImg;
}

- (UIImage *)lowerRightImage:(UIImage *)image1 Image2:(UIImage *)image2 {
    CGRect rect = CGRectMake(0, 0, image2.size.width, image2.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image2.CGImage);

    if (image1 != nil) {
#define BILI    4.0
        CGFloat width = image1.size.width / image2.size.width;//SCREEN_WIDTH;
        if (width > 0) {
            width = image1.size.width / width / BILI;
        }
        CGFloat height = 0;
        if (image1.size.width > 0) {
            height = width / image1.size.width;
            height = image1.size.height * height;
        }
        CGRect rc = CGRectMake(0, 0, width, height);
        rc.origin.x += rect.size.width - rc.size.width;
        //rc.origin.y += rect.size.height - rc.size.height;
        //[photo drawInRect:rc];
        
        //CGContextSetBlendMode(context, kCGBlendModeMultiply);
        //CGContextSetAlpha(context, 0.3);
        CGContextDrawImage(context, rc, image1.CGImage);
        //CGContextSetAlpha(context, 1.0);
    }
    
    //做CTM变换
    //CGContextTranslateCTM(context, translateX, translateY);
    //CGContextScaleCTM(context, 1.0, 1.0);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rect.size.height);

    //for (JHIdentifyText *obj in self.identifyTextArr) {
    //    NSString *text = obj.text;
    //    [text drawAtPoint:obj.position withAttributes:obj.attrs];
    //}
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

- (UIImage *)leftRightImage:(UIImage *)image1 Image2:(UIImage *)image2 {
    CGSize size1 = image1.size;
    CGSize size2 = image2.size;
    CGRect rectFull = CGRectMake(0, 0, size1.width+size2.width, size1.height);
    
    UIGraphicsBeginImageContext(rectFull.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rectFull.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, size1.width, size1.height), image2.CGImage);
    CGContextDrawImage(context, CGRectMake(size1.width, 0, size2.width, size2.height), image1.CGImage);

    //做CTM变换
    //CGContextTranslateCTM(context, translateX, translateY);
    //CGContextScaleCTM(context, 1.0, 1.0);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rectFull.size.height);
    
    //for (JHIdentifyText *obj in self.identifyTextArr) {
    //    NSString *text = obj.text;
    //    [text drawAtPoint:obj.position withAttributes:obj.attrs];
    //}
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    __weak JHIdentifyCapture *weakSelf = self;
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:^{
        //[weakSelf uploadImage:image];
        //[weakSelf returnImage:image Image2:nil];
        weakSelf.autoCapture.secretlyCamera = weakSelf.secretlyCamera;
        [weakSelf.autoCapture showCameraView:NO completion:^(UIImage *image1, UIImage *image2) {
            image2 = [weakSelf fixOrientation:image];
            [weakSelf returnImage:image1 Image2:image2];
        }];
    }];
    
    //    [self performSelector:@selector(selectPicture:) withObject:image afterDelay:0.1];
    //    [self performSelector:@selector(uploadImage:) withObject:image afterDelay:0.1];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    /*if (![JHGlobalVar isWhiteSkinColor]) {
        viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        viewController.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    } else {
        viewController.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
        viewController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    }*/
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark hsg
-(UIViewController *)viewController
{
    if (!_viewController) {
        _viewController = [[UIApplication sharedApplication] keyWindow];
    }
    return _viewController;
}

- (CGFloat)getLeftRightMargin
{
    if (self.leftRightMargin >= 0) {
        return self.leftRightMargin;
    }
    return self.resultImage.size.width / -self.leftRightMargin;
}

- (CGFloat)getTopBottomMargin
{
    if (self.topBottomMargin >= 0) {
        return self.topBottomMargin;
    }
    return self.resultImage.size.height / -self.topBottomMargin;
}

// 取得摄像头容器视图
- (UIImageView *)getCaptureImageView
{
    return self.autoCapture.imageView;
}

// 设置摄像头容器视图
- (void)setCaptureImageView:(UIImageView *)imageView
{
    self.autoCapture.imageView = imageView;
}

// 设置摄像头容器不被底层持有
- (void)setNoHoldImageView
{
    self.autoCapture.noHoldImageView = YES;
}

// 设置摄像掩码图像
- (void)setMaskImage:(UIImage *)img
{
    self.autoCapture.maskImage = img;
}

@end
