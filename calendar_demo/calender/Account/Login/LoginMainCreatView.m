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
}

- (IBAction)btnGoogleClick:(id)sender {
}

- (IBAction)btnAddPhotoClick:(id)sender {
}

- (IBAction)btnSignUpClick:(id)sender {
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
