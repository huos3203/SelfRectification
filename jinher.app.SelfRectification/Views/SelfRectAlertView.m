//
//  SelfRectAlertView.m
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import "SelfRectAlertView.h"
#ifdef iSmallApp
//    #import <SDWebImage/UIImageView+WebCache.h>
#else
    #import "UIImageView+WebCache.h"
#endif
#import "UIImageView+WebCache.h"
@interface SelfRectAlertView()

@property (strong, nonatomic) IBOutlet UIView *ibAlertView;
@property (strong, nonatomic) IBOutlet UILabel *ibTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ibImgView;
@property (strong, nonatomic) IBOutlet UITextView *ibTextView;
@property (strong, nonatomic) IBOutlet UIButton *ibCloseBut;

@end

@implementation SelfRectAlertView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _ibAlertView.layer.cornerRadius = 8;
    _ibImgView.layer.cornerRadius = 8;
    _ibImgView.layer.masksToBounds = true;
}

///隐藏
- (IBAction)ibaCloseAction:(id)sender {
    [self setHidden:YES];
}
-(void)showAlertView:(BOOL)isShow
{
    if (isShow) {
        //显示提示框
        [_ibAlertView setHidden:NO];
    }else{
        /// 仅显示遮罩
         [_ibAlertView setHidden:YES];
    }
    [self setHidden:NO];
}

-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg imgUrl:(NSString *)url
{
    _ibTitleLabel.text = title;
    _ibTextView.text = msg;
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [_ibImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"example@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
}
@end
