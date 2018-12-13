//
//  RectiCollCell.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/13.
//  Copyright © 2018年 Jinher. All rights reserved.
//

#import "RectiCollCell.h"

@implementation RectCollModel

@end

@interface RectiCollCell()
@property (strong, nonatomic) IBOutlet UILabel *ibRectTitleLabel;

@end
@implementation RectiCollCell
-(void)setModel:(RectCollModel *)model
{
    _model = model;
    _ibRectTitleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    if (selected) {
        _ibRectTitleLabel.textColor = [UIColor whiteColor];
        
    }else{
        _ibRectTitleLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
}

@end
