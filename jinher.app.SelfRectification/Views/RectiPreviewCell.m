//
//  RectiPreviewCell.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/19.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import "RectiPreviewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RectiPreviewCell()

@property (strong, nonatomic) IBOutlet UILabel  *ibTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ibContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ibImgView;

@end

@implementation RectiPreModel

@end

@implementation RectiPreviewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    //自定义UI
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setModel:(RectiPreModel *)model
{
    _model = model;
    _ibTitleLabel.text = model.title;
    _ibContentLabel.text = model.content;
    [_ibImgView sd_setImageWithURL:[NSURL URLWithString:model.imgURL]];
}

@end
