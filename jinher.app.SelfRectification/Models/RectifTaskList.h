//
//  RectifTaskList.h
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "JSONModel.h"

@interface ComInspectOptionGuide : JSONModel
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString <Optional>*Text;
@property (assign, nonatomic) NSInteger Order;
@property (strong, nonatomic) NSString <Optional>*Picture;
@end

@interface ComInspectOption : JSONModel
@property (strong, nonatomic) NSString *InspectOptionId;
@property (strong, nonatomic) NSString *OptionTaskId;
@property (strong, nonatomic) NSString <Optional>*Text;
@property (strong, nonatomic) NSString <Optional>*Remark;
@property (strong, nonatomic) NSString <Optional>*Picture;
@property (strong, nonatomic) NSString <Optional>*InspectMethod;
@property (strong, nonatomic) NSString <Optional>*NoticeTime;
@property (strong, nonatomic) NSString *CompletionCriteria;
@property (strong, nonatomic) NSString *ClassificationId;
@property (strong, nonatomic) NSString *ClassificationName;
@property (assign, nonatomic) BOOL IsCompleted;
@property (assign, nonatomic) BOOL IsVoicePlay;
@property (strong, nonatomic) NSArray<ComInspectOptionGuide*> <Optional>*ComInspectOptionGuideList;
@end

@interface RectifTask : JSONModel
@property (strong, nonatomic) NSString *ClassificationId;
@property (strong, nonatomic) NSString *ClassificationName;
@property (assign, nonatomic) BOOL IsCompleted;
@property (strong, nonatomic) NSArray<ComInspectOption *> <Optional>*ComInspectOptionList;

@end
