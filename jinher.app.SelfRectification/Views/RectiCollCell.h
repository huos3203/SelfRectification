//
//  RectiCollCell.h
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/13.
//  Copyright © 2018年 Jinher. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RectCollModel:NSObject
@property (strong, nonatomic) NSString *title;
@end

@interface RectiCollCell : UICollectionViewCell
@property (strong, nonatomic) RectCollModel *model;
@end

