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

#pragma mark — 实现自适应文字宽度的关键步骤:item的layoutAttributes
//preferredLayoutAttributesFittingAttributes: 方法默认调整Size属性来适应 self-sizing Cell，所以重写的时候需要先调用父类方法，再在返回的 UICollectionViewLayoutAttributes 对象上做你想要做的修改。
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    @try {
        CGRect rect = [_ibRectTitleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        rect.size.width +=20;
        rect.size.height+=12;
        attributes.frame = rect;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return attributes;
    
}
@end
