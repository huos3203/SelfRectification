//
//  ReqRectifServer.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "ReqRectifServer.h"
#import "JHURLRequest.h"
#import "LoginAndRegister.h"
#import "JHProjectCommonData.h"
#import "RectifOptPics.h"
#import "AddRectTask.h"
#import "RectifTaskList.h"
///检查项列表
#define GetComInspectTaskList @"rips.iuoooo.com/Jinher.AMP.RIP.SV.ComInspectTaskSV.svc/GetComInspectTaskList"
///自检项提交图片接口
#define SaveComInspectOption @"rips.iuoooo.com/Jinher.AMP.RIP.SV.ComInspectTaskSV.svc/SaveComInspectOption"
///自检分类点击已完成，预览接口
#define GetComInspectOptionPics @"rips.iuoooo.com/Jinher.AMP.RIP.SV.ComInspectTaskSV.svc/GetComInspectOptionPics"
@implementation ReqRectifServer
+(id)shared {
    static ReqRectifServer *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (JHURLRequest *)request {
    if (!_request) {
        _request = [[JHURLRequest alloc] init];
    }
    return _request;
}

-(void)reqGetComInspectTaskList:(NSString *)storeId handler:(void(^)(NSArray<RectifTask *> *))handler
{
    NSString *appId = [JHProjectCommonData getProjectInfoDicAppID];
    NSString *userId = [[LoginAndRegister sharedLoginAndRegister] getUserID];
    NSDictionary *param = @{@"appId":@"8dd31412-92d8-4838-879a-712f8cc75a79",
                            @"userId":@"d356df00-1c40-448f-9656-da959808fc30",
                            @"storeId":@"451938b2-b54b-4f07-ad17-88e374bd05f2"};
    [self.request startPOSTRequestWithUrl:GetComInspectTaskList
                               parameters:@{@"commonParam":param}
                                resHander:^(NSDictionary *resData) {
                                    BOOL isSuccess = [[resData objectForKey:@"IsSuccess"] boolValue];
                                    NSArray *data = [resData objectForKey:@"Content"];
                                    if (isSuccess && ![data isKindOfClass:[NSNull class]]) {
                                        NSArray* model = [RectifTask arrayOfModelsFromDictionaries:data];
                                        handler(model);
                                    }else{
                                        handler(nil);
                                    }
                                } resError:^(NSString *error) {
                                    handler(nil);
                                }];
}

-(void)reqAddRectTask:(AddRectTask *)model handler:(void(^)(BOOL))handler
{
    NSDictionary *param = [model toDicData];
    [self.request startPOSTRequestWithUrl:SaveComInspectOption parameters:param resHander:^(NSDictionary *resData) {
        BOOL isSuccess = [[resData objectForKey:@"IsSuccess"] boolValue];
        handler(isSuccess);
    }resError:^(NSString *error) {
        handler(nil);
    }];
}


-(void)reqGetComInspectOptionPics:(NSString *)storeId handler:(void(^)(NSArray<RectifOptPics *> *))handler
{
    NSString *appId = [JHProjectCommonData getProjectInfoDicAppID];
    NSString *userId = [[LoginAndRegister sharedLoginAndRegister] getUserID];
    NSDictionary *param = @{@"appId":appId,@"userId":userId,@"storeId":storeId};
    [self.request startPOSTRequestWithUrl:GetComInspectOptionPics
                               parameters:@{@"commonParam":param}
                                resHander:^(NSDictionary *resData) {
                                    BOOL isSuccess = [[resData objectForKey:@"IsSuccess"] boolValue];
                                    NSArray *data = [resData objectForKey:@"Content"];
                                    if (isSuccess && ![data isKindOfClass:[NSNull class]]) {
                                        NSArray* model = [RectifOptPics arrayOfModelsFromDictionaries:data];
                                        handler(model);
                                    }else{
                                        handler(nil);
                                    }
                                } resError:^(NSString *error) {
                                    handler(nil);
                                }];
}

@end
