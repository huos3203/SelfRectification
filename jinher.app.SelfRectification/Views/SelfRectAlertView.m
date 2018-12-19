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
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *url = @"http://192.168.1.44/assets/brand_logo-c37eb221b456bb4b472cc1084480991f.png";
    [_ibImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"example@3x" inBundle:bundle compatibleWithTraitCollection:nil]];
}

///隐藏
- (IBAction)ibaCloseAction:(id)sender {
    [self setHidden:YES];
}


@end
