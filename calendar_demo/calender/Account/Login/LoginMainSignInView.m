//
//  LoginMainSignInView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainSignInView.h"

@implementation LoginMainSignInView
@synthesize delegate;

- (IBAction)btnFacebookClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnFacebookSignInDidClick)]) {
        [self.delegate btnFacebookSignInDidClick];
    }
}

- (IBAction)btnGoogleClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnGoogleSignInDidClick)]) {
        [self.delegate btnGoogleSignInDidClick];
    }
}

- (IBAction)btnSignInClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnSignInDidClick)]) {
        [self.delegate btnSignInDidClick];
    }
}

- (IBAction)btnForgotPasswordClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnForgotPasswordDidClick)]) {
        [self.delegate btnForgotPasswordDidClick];
    }
}


- (void)updateUI
{
    
}

+(LoginMainSignInView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainSignInView" owner:self options:nil];
    LoginMainSignInView * view = (LoginMainSignInView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}



@end
