//
//  RectifTaskList.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "RectifTaskList.h"

@implementation ComInspectOptionGuide

@end

@implementation ComInspectOption

-(NSArray<ComInspectOptionGuide *> *)ComInspectOptionGuideList
{
    if (_ComInspectOptionGuideList.count > 0 && [[_ComInspectOptionGuideList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        _ComInspectOptionGuideList = [ComInspectOptionGuide arrayOfModelsFromDictionaries:_ComInspectOptionGuideList];
    }
    return _ComInspectOptionGuideList;
}



@end

@implementation RectifTask

-(NSArray<ComInspectOption *> *)ComInspectOptionList
{
    if (_ComInspectOptionList.count > 0 && [[_ComInspectOptionList objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        _ComInspectOptionList = [ComInspectOption arrayOfModelsFromDictionaries:_ComInspectOptionList];
    }
    return _ComInspectOptionList;
}

@end
