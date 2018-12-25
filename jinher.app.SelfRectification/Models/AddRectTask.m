//
//  AddRectTask.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "AddRectTask.h"
#import "LoginAndRegister.h"
#import "JHProjectCommonData.h"
@implementation RectOptPics


@end

@implementation RectifOptModel

-(NSString *)UserId
{
    return [[LoginAndRegister sharedLoginAndRegister] getUserID];
}

-(NSString *)AppId
{   
    return [JHProjectCommonData getProjectInfoDicAppID];
}

-(NSMutableArray<RectOptPics *> *)OptionPicsList
{
    if (!_OptionPicsList) {
        _OptionPicsList = [NSMutableArray new];
    }
    return _OptionPicsList;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"OptionPicsList" : [RectOptPics class]};
}
-(NSDictionary *)toDicData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"UserId",self.UserId,@"StoreId",self.StoreId,@"AppId",self.AppId,@"InspectOptionId",self.InspectOptionId,@"ClassificationId",self.ClassificationId,@"Order",self.Order, nil];
    NSMutableArray *picArr = [NSMutableArray new];
    for (RectOptPics *pic in self.OptionPicsList) {
        [picArr addObject:pic];
    }
    [dic setObject:picArr forKey:@"OptionPicsList"];
    return dic;
}
@end

@implementation AddRectTask

-(NSMutableArray *)optionTaskIds
{
    if (!_optionTaskIds) {
        _optionTaskIds = [NSMutableArray new];
    }
    return _optionTaskIds;
}

-(RectifOptModel *)option
{
    if (!_option) {
        _option = [RectifOptModel new];
    }
    return _option;
}
-(NSDictionary *)toDicData
{
    NSMutableDictionary *dics = [NSMutableDictionary new];
    [dics setObject:self.optionTaskIds forKey:@"optionTaskIds"];
    NSDictionary *optDic = [self.option toDicData];
    [dics setObject:optDic forKey:@"option"];
    return dics;
}
@end
