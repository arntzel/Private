//
//  LoginMainCreatView.h
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateUser.h"

@protocol LoginMainCreatViewDelegate <NSObject>

- (void)btnFacebookSignUpDidClick;

- (void)btnGoogleSignUpDidClick;

- (void)btnSignUpDidClickWithName:(CreateUser *) createUser;

@end

@interface LoginMainCreatView : UIView


-(void) showLoadingAnimation:(BOOL)show;


+(LoginMainCreatView *) creatView;

@property(nonatomic,weak) UIViewController<LoginMainCreatViewDelegate> *delegate;

@end
