//
//  JHIdentifyCapture.h
//  JHUniversalApp
//
//  Created by jinher on 2018/7/23.
//  Copyright © 2018年  William Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 合成方法
typedef enum : NSUInteger {
    ComplexMethodLowerRight,    // 右下角小图像
    ComplexMethodLeftRight,     // 左右布局
} ComplexMethod;

// 对齐方式
typedef enum : NSUInteger {
    IdentifyAlignTopLeft,       // 左上
    IdentifyAlignTopRight,      // 右上
    IdentifyAlignBottomLeft,    // 左下
    IdentifyAlignBottomRight,   // 右下
} IdentifyAlign;

@interface JHIdentifyCapture : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, assign) ComplexMethod complexMethod;  // 合成方式
@property (nonatomic, assign) BOOL secretlyCamera;
@property (nonatomic, assign) BOOL isCaptureTmout;
@property (nonatomic, assign) NSTimeInterval captureTmoutS;
@property (nonatomic, assign) CGFloat topBottomMargin;
@property (nonatomic, assign) CGFloat leftRightMargin;
//@property (nonatomic, copy) NSString *waterText;    // 水印文字

// 捕获图像,返回合成后的图像
//- (int)captureImage:(CaptureOptions)options completion:(void(^)(UIImage *complexImage))handler;
- (int)captureImage:(void(^)(UIImage *image))handler;

// 取消抓拍
- (int)cancelCapture;

// 是否正在抓拍
- (BOOL)isCapturing;

//- (int)addText:text withAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs AndPosition:(CGPoint)pos;
//- (int)addText:text WithFont:(UIFont *)font AndPosition:(CGPoint)pos;

// 增加文字
- (int)addText:(NSString *)text WithFont:(UIFont *)font AndAlign:(IdentifyAlign)align;

// 增加文字2
- (int)addText:(NSString *)text Text2:(NSString *)text2 WithFont:(UIFont *)font AndAlign:(IdentifyAlign)align;

// 返回合成图像
- (UIImage *)complexText;

// 取得摄像头容器视图
- (UIImageView *)getCaptureImageView;

// 设置摄像头容器视图
- (void)setCaptureImageView:(UIImageView *)imageView;

// 设置摄像头容器不被底层持有
- (void)setNoHoldImageView;

// 设置摄像掩码图像
- (void)setMaskImage:(UIImage *)img;

@end
