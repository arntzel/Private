//
//  LoginMainSignInView.h
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginMainSignInViewDelegate <NSObject>

- (void)btnFacebookSignInDidClick;

- (void)btnGoogleSignInDidClick;

- (void)btnSignInDidClickWithName:(NSString *)name Password:(NSString *)password;

- (void)btnForgotPasswordDidClick;

@end

@interface LoginMainSignInView : UIView

+(LoginMainSignInView *) creatView;

@property(nonatomic,weak) id<LoginMainSignInViewDelegate> delegate;


-(void) setEmail:(NSString *) email andPass:(NSString *) pass;

-(void) showLogining:(BOOL) logining;

@end
