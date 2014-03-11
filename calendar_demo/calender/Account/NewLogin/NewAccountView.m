//
//  NewAccountView.m
//  Calvin
//
//  Created by Kevin Wu on 3/9/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "NewAccountView.h"
#import "ViewUtils.h"
#import "UIColor+Hex.h"

@implementation NewAccountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) awakeFromNib
{
    UIColor *textBgColor = [UIColor colorWithRed:232.0/255.0 green:243.0/255.0 blue:237.0/255.0 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.profileView setBackgroundColor:textBgColor];
    [self.infoView setBackgroundColor:textBgColor];
    
    [self.firstName setBorderStyle:UITextBorderStyleNone];
    [self.firstName setBackgroundColor:[UIColor clearColor]];
    self.firstName.placeholder = @"First Name";
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.firstName.returnKeyType = UIReturnKeyNext;
    [self.firstName setFont:font];
    
    [self.lastName setBorderStyle:UITextBorderStyleNone];
    [self.lastName setBackgroundColor:[UIColor clearColor]];
    self.lastName.placeholder = @"Last Name";
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.lastName.returnKeyType = UIReturnKeyNext;
    [self.lastName setFont:font];
    
    [self.zipCode setBorderStyle:UITextBorderStyleNone];
    [self.zipCode setBackgroundColor:[UIColor clearColor]];
    self.zipCode.placeholder = @"Zip Code";
    self.zipCode.autocorrectionType = UITextAutocorrectionTypeNo;
    self.zipCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.zipCode.returnKeyType = UIReturnKeyNext;
    [self.zipCode setFont:font];
    
    CALayer *lay  = self.avatar.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:35.0];
    [lay setBorderWidth:1];
    [lay setBorderColor:[UIColor lightGrayColor].CGColor];
    
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.email setBackgroundColor:[UIColor clearColor]];
    self.email.placeholder = @"Email Address";
    self.email.autocorrectionType = UITextAutocorrectionTypeNo;
    self.email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.email.returnKeyType = UIReturnKeyNext;
    [self.email setFont:font];
    
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.password setBackgroundColor:[UIColor clearColor]];
    self.password.placeholder = @"Password";
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.returnKeyType = UIReturnKeyNext;
    [self.password setFont:font];
    
    [self.confirmPassword setBorderStyle:UITextBorderStyleNone];
    [self.confirmPassword setBackgroundColor:[UIColor clearColor]];
    self.confirmPassword.placeholder = @"Confirm Password";
    self.confirmPassword.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmPassword.returnKeyType = UIReturnKeyNext;
    [self.confirmPassword setFont:font];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.lastName resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.zipCode resignFirstResponder];
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

+(NewAccountView *) create
{
    return (NewAccountView *)[ViewUtils createView:@"NewAccountView"];
}

@end
