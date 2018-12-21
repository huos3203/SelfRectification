//
//  SelfRectAlertView.h
//  jinher.app.SelfRectification
//
//  Created by admin on 2018/12/17.
//  Copyright © 2018 Jinher. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SelfRectAlertView : UIView
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg imgUrl:(NSString *)url;
-(void)showAlertView:(BOOL)isShow;
@end

