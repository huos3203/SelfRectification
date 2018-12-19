//
//  RectiPreviewCell.h
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/19.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectiPreModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imgURL;
@property (strong, nonatomic) NSString *content;
@end

@interface RectiPreviewCell : UICollectionViewCell
@property (strong, nonatomic) RectiPreModel *model;

@end
