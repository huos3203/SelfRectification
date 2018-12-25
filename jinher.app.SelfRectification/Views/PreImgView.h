//
//  PreImgBtnView.h
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RectiPreModel;
@class HSProgressPopUpView;
@interface PreImgView : UIView
@property (strong, nonatomic) RectiPreModel *model;
@property (strong, nonatomic) IBOutlet UIButton *ibPreImgBtn;
@property (strong, nonatomic) IBOutlet HSProgressPopUpView *progressView;
@property (strong, nonatomic) NSMutableArray<RectiPreModel *> *allUploadArr;
@property (strong, nonatomic) void(^Completehander)(NSString *);
-(void)startUploadTitle:(NSString *)title img:(UIImage *)img guideId:(NSString *)guideId InspectOptionId:(NSString *)optId order:(NSInteger)order handler:(void(^)(NSString *))hander;
@end



@interface PreImgView (MHLazyTableImages)

@end
