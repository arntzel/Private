//
//  LoginMainSignInView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainSignInView.h"

@implementation LoginMainSignInView

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
