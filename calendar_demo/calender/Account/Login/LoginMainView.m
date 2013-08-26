//
//  loginMainView.m
//  test
//
//  Created by zyax86 on 8/26/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "loginMainView.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginMainView()
@property (retain, nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (retain, nonatomic) IBOutlet UIButton *btnSignIn;

@end

@implementation LoginMainView


- (void)updateUI
{
    [self.btnCreateAccount setBackgroundColor:[UIColor colorWithRed:62/255.0 green:194/255.0f blue:115/255.0f alpha:1.0]];
    [self.btnCreateAccount.layer setCornerRadius:5.0f];
    
    
    [self.btnSignIn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0f blue:255/255.0f alpha:0.16]];
    
    [self.btnSignIn.layer setCornerRadius:5.0f];
    [self.btnSignIn.layer setBorderColor:[UIColor colorWithRed:1.0f green:1.0 blue:1.0 alpha:0.06].CGColor];
    [self.btnSignIn.layer setBorderWidth:2.0f];
}



- (IBAction)btnCreateAccountClick:(id)sender {
}

- (IBAction)btnSignInClick:(id)sender {
}

+(LoginMainView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainView" owner:self options:nil];
    LoginMainView * view = (LoginMainView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

- (void)dealloc {
    [_btnCreateAccount release];
    [_btnSignIn release];
    [super dealloc];
}
@end
