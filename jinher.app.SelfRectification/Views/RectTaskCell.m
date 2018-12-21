//
//  RectTaskCell.m
//  JHSelfInspectSDK
//
//  Created by admin on 2018/12/21.
//  Copyright © 2018 huoshuguang. All rights reserved.
//

#import "RectTaskCell.h"
#import "RectifTaskList.h"

@interface RectTaskCell()
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibStatusLabel;


@end

@implementation RectTaskCell
{
    UIView *reddot;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    reddot = [[UIView alloc] init];
    reddot.frame = CGRectMake(90,73.5,10,10);
    reddot.backgroundColor = [UIColor colorWithRed:251/255.0 green:88/255.0 blue:73/255.0 alpha:1];
    reddot.layer.cornerRadius = 5;
    float labelW = _ibStatusLabel.frame.size.width;
    reddot.center = CGPointMake(labelW, 14);
    [_ibStatusLabel addSubview:reddot];
}

-(void)setModel:(RectifTask *)model
{
    _model = model;
    _ibTitleLabel.text = model.ClassificationName;
    if (model.IsCompleted) {
        _ibStatusLabel.text = @"已完成";
        reddot.hidden = YES;
    }else{
        _ibStatusLabel.text = @"未完成";
        reddot.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
