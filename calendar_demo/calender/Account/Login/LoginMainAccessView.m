//
//  loginMainView.m
//  test
//
//  Created by zyax86 on 8/26/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainAccessView.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginMainAccessView()
@property (weak, nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

@end

@implementation LoginMainAccessView
@synthesize delegate;

- (IBAction)btnCreateAccountClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnCreateAccountDidClick)]) {
        [self.delegate btnCreateAccountDidClick];
    }
}

- (IBAction)btnSignInClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnSignInDidClick)]) {
        [self.delegate btnSignInDidClick];
    }
}

- (void)updateUI
{
    
}

+(LoginMainAccessView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainAccessView" owner:self options:nil];
    LoginMainAccessView * view = (LoginMainAccessView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}
@end
