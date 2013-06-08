//
//  LoginView.h
//  calender
//
//  Created by fang xiang on 13-6-8.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView


+(LoginView *) createView;

@property IBOutlet UIButton * signupGoogle;
@property IBOutlet UIButton * signupFacebook;
@property IBOutlet UIButton * signupEmail;

@property IBOutlet UILabel * loginnow;

@end
