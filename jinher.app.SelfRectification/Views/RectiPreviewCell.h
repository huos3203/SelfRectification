//
//  RectiPreviewCell.h
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/19.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveCameraModel.h"
//@class ArchiveCameraModel;
@interface RectiPreModel : ArchiveCameraModel
@property (strong, nonatomic) NSString *guideId;
@property (strong, nonatomic) NSString *optId;
@property (assign, nonatomic) NSInteger order;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@end

@interface RectiPreviewCell : UICollectionViewCell
@property (strong, nonatomic) RectiPreModel *model;

@end
