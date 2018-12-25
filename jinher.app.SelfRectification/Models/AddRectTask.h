//
//  AddRectTask.h
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/20.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "JSONModel.h"

@interface RectOptPics : JSONModel
@property (strong, nonatomic) NSString *PictureSrc;
@property (assign, nonatomic) NSInteger Order;
@property (strong, nonatomic) NSString *InspectOptionGuideId;
@end

@interface RectifOptModel : JSONModel
@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *StoreId;
@property (strong, nonatomic) NSString *AppId;
@property (strong, nonatomic) NSString *InspectOptionId;
@property (strong, nonatomic) NSString *ClassificationId;
@property (strong, nonatomic) NSString *Order;
@property (strong, nonatomic) NSMutableArray<RectOptPics *> *OptionPicsList;
-(NSDictionary *)toDicData;
@end

@interface AddRectTask : JSONModel
@property (strong, nonatomic) NSMutableArray *optionTaskIds;
@property (strong, nonatomic) RectifOptModel *option;
-(NSDictionary *)toDicData;
@end

