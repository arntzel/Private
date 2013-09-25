//
//  LoginMainCreatView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainCreatView.h"

@interface LoginMainCreatView()
@property (weak, nonatomic) IBOutlet UITextField *textFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textLastName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;


@end

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

    [self endEditing:YES];
    
}

- (IBAction)btnSignUpClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(btnSignUpDidClickWithName:Email:Password:HeadPhoto:)]) {
        NSString *userName = [NSString stringWithFormat:@"%@%@",self.textFirstName.text,self.textLastName.text];
        [self.delegate btnSignUpDidClickWithName:userName Email:self.textEmail.text Password:self.textPassword.text HeadPhoto:nil];
    }
}

- (void)updateUI
{
    UITapGestureRecognizer* singleTapRecognizer;
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleTapRecognizer];
}

+(LoginMainCreatView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainCreatView" owner:self options:nil];
    LoginMainCreatView * view = (LoginMainCreatView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
