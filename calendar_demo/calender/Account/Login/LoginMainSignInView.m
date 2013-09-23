//
//  LoginMainSignInView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainSignInView.h"

@interface LoginMainSignInView()

@property (weak, nonatomic) IBOutlet UITextField *TextUserName;
@property (weak, nonatomic) IBOutlet UITextField *TextPassword;


@end

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
    if ([self.delegate respondsToSelector:@selector(btnSignInDidClickWithName:Password:)]) {
        [self.delegate btnSignInDidClickWithName:self.TextUserName.text Password:self.TextPassword.text];
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
