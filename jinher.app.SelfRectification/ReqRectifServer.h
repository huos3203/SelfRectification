//
//  ReqRectifServer.h
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHURLRequest.h"
@class RectifOptPics;
@class AddRectTask;
@class RectifTask;
@interface ReqRectifServer : NSObject
+(id)shared;
@property (nonatomic, strong) JHURLRequest * request;

-(void)reqAddRectTask:(AddRectTask *)model handler:(void(^)(BOOL))handler;
-(void)reqGetComInspectTaskList:(NSString *)storeId handler:(void(^)(NSArray<RectifTask *> *))handler;
-(void)reqGetComInspectOptionPics:(NSString *)storeId handler:(void(^)(NSArray<RectifOptPics *> *))handler;


@end

