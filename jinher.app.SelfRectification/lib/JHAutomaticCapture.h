//
//  JHAutomaticCapture.h
//  JHUniversalApp
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年  jinher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface JHAutomaticCapture : NSObject
@property (nonatomic, assign) BOOL secretlyCamera;
@property (nonatomic, assign) BOOL isCaptureTmout;
@property (nonatomic, assign) BOOL noHoldImageView;
@property (nonatomic, assign) NSTimeInterval captureTmoutS;
//@property (nonatomic, strong) UIImageView *foregndImageView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *maskImage;
- (int)showCameraView:(BOOL)captureRear completion:(void(^)(UIImage *image1, UIImage *image2))handler;
- (void)disposeCamare;
- (BOOL)isCamaring;
@end
