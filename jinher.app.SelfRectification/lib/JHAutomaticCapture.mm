//
//  JHAutomaticCapture.m
//  JHUniversalApp
//
//  Created by admin on 2018/7/2.
//  Copyright © 2018年  William Sterling. All rights reserved.
//

#import "JHAutomaticCapture.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/imgproc_c.h>

static CIDetector *g_faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:[CIContext contextWithOptions:nil] options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];

static CIDetector *g_rectDetector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:[CIContext contextWithOptions:nil] options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]];

@interface JHAutomaticCapture ()<CvVideoCameraDelegate>
{
    cv::Mat keepMatImg;
    NSTimeInterval delayLimit;
    time_t _captureStartS;
}
@property (assign, nonatomic) BOOL captureRear;
@property (strong, nonatomic) UIImage *resultimage1;
@property (strong, nonatomic) UIImage *resultimage2;
@property (strong, nonatomic) CvVideoCamera *videoCamera;
@property (strong, nonatomic) void(^HandleImage)(UIImage *image1, UIImage *image2);
//@property (strong, nonatomic) UIImage *testImage;
@end

@implementation JHAutomaticCapture

- (void)dealloc {
    //NSLog(@"JHAutomaticCapture dealloc");
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        CGSize mainSize = [UIScreen mainScreen].bounds.size;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width - 120, 20, 120, 212)];
        _imageView.backgroundColor = [UIColor clearColor];
        /*if (self.foregndImageView == nil) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"wu@2x" ofType:@"png"];
            self.maskImage = [UIImage imageWithContentsOfFile:path];
/ *
            self.foregndImageView = [[UIImageView alloc] initWithFrame:_imageView.bounds];
            self.foregndImageView.image = self.maskImage;
            [_imageView autoresizesSubviews];
            [_imageView addSubview:self.foregndImageView];
            [_imageView bringSubviewToFront:self.foregndImageView];
            [_imageView autoresizesSubviews];
* /
            //_imageView.image = self.maskImage;
            //_imageView.layer.contents = (id)self.maskImage.CGImage;
            //[_imageView.layer addSublayer:
        }*/
        if (self.secretlyCamera) {
            [_imageView setHidden:YES];
        }
    }
    return _imageView;
}

- (int)showCameraView:(BOOL)captureRear completion:(void(^)(UIImage * image1, UIImage *image2))handler{
    _captureStartS = time(NULL);
    self.isCaptureTmout = NO;
    //self.testImage = [UIImage imageNamed:@"Default.png"];
    delayLimit = 60;//limitS;
    self.captureRear = captureRear;
    self.resultimage1 = nil;
    self.resultimage2 = nil;
    self.HandleImage = handler;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted == YES) {
                        if (!self.noHoldImageView) {
                            UIView * topView = [[UIApplication sharedApplication] keyWindow];
                            [topView addSubview:self.imageView];
                        }
                        [self createVideo];
                    }else{
                        
                    }
                });
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
            
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
        {
            if (!self.noHoldImageView) {
                UIView * topView = [[UIApplication sharedApplication] keyWindow];
                [topView addSubview:self.imageView];
            }
            [self createVideo];
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (void)createVideo {
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    //    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    //    self.videoCamera.defaultFPS = 30;
    //设置摄像头的方向
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    [self.videoCamera start];
    //[self performSelector:@selector(autoCloseViewWhenTakePhotoFailure) withObject:nil afterDelay:delayLimit];
}

- (void)autoCloseViewWhenTakePhotoFailure{
    [self saveKeepMatImg];
}

- (void)disposeCamare {
    [self.videoCamera stop];
    self.videoCamera.delegate = nil;
    self.videoCamera = nil;
    self.maskImage = nil;
    self.noHoldImageView = NO;
}

- (BOOL)isCamaring {
    return ( self.videoCamera != nil ? YES : NO );
}

- (void)finishTakePhoto{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoCloseViewWhenTakePhotoFailure) object:nil];
    [self disposeCamare];
}

//按行合并如下：
cv::Mat mergeRows(cv::Mat A, cv::Mat B)
{
    // cv::CV_ASSERT(A.cols == B.cols&&A.type() == B.type());
    int totalRows = A.rows + B.rows;
    cv::Mat mergedDescriptors(totalRows, A.cols, A.type());
    cv::Mat submat = mergedDescriptors.rowRange(0, A.rows);
    A.copyTo(submat);
    submat = mergedDescriptors.rowRange(A.rows, totalRows);
    B.copyTo(submat);
    return mergedDescriptors;
}
//按列合并如下：
cv::Mat mergeCols(cv::Mat A, cv::Mat B)
{
    // cv::CV_ASSERT(A.cols == B.cols&&A.type() == B.type());
    int totalCols = A.cols + B.cols;
    cv::Mat mergedDescriptors(A.rows,totalCols, A.type());
    cv::Mat submat = mergedDescriptors.colRange(0, A.cols);
    A.copyTo(submat);
    submat = mergedDescriptors.colRange(A.cols, totalCols);
    B.copyTo(submat);
    return mergedDescriptors;
}

- (void)processImage:(cv::Mat &)image {
    if (self.maskImage != nil) {
        cv::Mat m;
        UIImageToMat(self.maskImage, m);
        cv::Mat n = mergeRows(image, m);
        n.copyTo(image);
        //cv::rectangle(image, cv::Rect(10,10,30,100),cv::Scalar(0,0,255));
        //cvRectangleR(image, cvRect(10, 10, 50, 50), cvScalar())
    }
    
    cv::Mat outCopyImg;
    image.copyTo(outCopyImg);
    cv::cvtColor(outCopyImg, outCopyImg, CV_BGR2RGB);
    keepMatImg = outCopyImg;
    if (self.resultimage1 == nil) {
        //UIImage *img = MatToUIImage(outCopyImg);
        UIImage *img = MatToUIImage(image);
        if ([self isPhotoContainsFeature:img]) {
            if ([self isPhotoIsBrightness:image] == YES) {
                [self saveKeepMatImg];
            }
        }
        img = nil;
    } else {
        if ([self isPhotoIsBrightness:image] == YES) {
            [self saveKeepMatImg];
        }
    }
    //outCopyImg.release();
}

-(void)saveKeepMatImg
{
    if (self.resultimage1 == nil) {
        if (self.captureRear) {
            self.resultimage1 = MatToUIImage(keepMatImg);
            //self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
            [self.videoCamera switchCameras];
        } else {
            [self disposeCamare];
            self.resultimage1 = MatToUIImage(keepMatImg);
            __weak JHAutomaticCapture *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.HandleImage(weakSelf.resultimage1, weakSelf.resultimage2);
                if (!self.noHoldImageView) {
                    [weakSelf.imageView removeFromSuperview];
                }
            });
        }
    } else {
        [self disposeCamare];
        self.resultimage2 = MatToUIImage(keepMatImg);
        __weak JHAutomaticCapture *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.HandleImage(weakSelf.resultimage1, weakSelf.resultimage2);
            if (!self.noHoldImageView) {
                [weakSelf.imageView removeFromSuperview];
            }
        });
    }
}


- (BOOL)isPhotoContainsFeature:(UIImage *)image{
    //CIContext * context = [CIContext contextWithOptions:nil];
    
    if (self.captureTmoutS > 0) {
        int intervalS = time(NULL) - _captureStartS;
        if (intervalS > self.captureTmoutS) {
            self.isCaptureTmout = YES;
            return YES;
        }
    }

    CIDetector * faceDetector = nil;
    if (self.resultimage1 == nil) {
        faceDetector = g_faceDetector;
        //NSDictionary * param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
        //NSDictionary * param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
        //faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:param];
    } else {
        faceDetector = g_rectDetector;
        //NSDictionary * param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
//        faceDetector = [CIDetector detectorOfType:CIDetectorAccuracyHigh context:context options:param];
        //faceDetector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:context options:param];
    }

    //CIImage * ciimage = [CIImage imageWithCGImage:self.testImage.CGImage];
    CIImage * ciimage = [CIImage imageWithCGImage:image.CGImage];
    //CIImage * ciimage = image.CIImage;
    NSArray * detectResult = [faceDetector featuresInImage:ciimage];

    BOOL ret = detectResult.count;
    //ciimage = nil;
    //detectResult = nil;
    //faceDetector = nil;
    return ret;
}
- (BOOL)isPhotoIsBrightness:(cv::Mat &)image
{
    if (self.captureTmoutS > 0) {
        int intervalS = time(NULL) - _captureStartS;
        if (intervalS > self.captureTmoutS + 4) {   // 再给4秒的时间
            self.isCaptureTmout = YES;
            return YES;
        }
    }

    cv::Mat imageSobel;
    Sobel(image, imageSobel, CV_16U, 1, 1);
    
    //图像的平均灰度
    double meanValue = 0.0;
    meanValue = mean(imageSobel)[0];
    
    if (meanValue > 1.3) {
        return YES;
    }
    return NO;
}

@end
