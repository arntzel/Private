//
//  LoginMainCreatView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainCreatView.h"

@implementation LoginMainCreatView
@synthesize delegate;

- (IBAction)btnFacebookClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnFacebookSignUpDidClick)]) {
        [self.delegate btnFacebookSignUpDidClick];
    }
}

- (IBAction)btnGoogleClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnGoogleSignUpDidClick)]) {
        [self.delegate btnGoogleSignUpDidClick];
    }
}

- (IBAction)btnAddPhotoClick:(id)sender {

    
}

- (IBAction)btnSignUpClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnSignUpDidClick)]) {
        [self.delegate btnSignUpDidClick];
    }
}

- (void)updateUI
{
    
}

+(LoginMainCreatView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainCreatView" owner:self options:nil];
    LoginMainCreatView * view = (LoginMainCreatView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
