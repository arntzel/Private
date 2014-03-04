//
//  AddLocationTextView.m
//  calender
//
//  Created by zyax86 on 9/3/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "AddLocationTextView.h"

@interface AddLocationTextView()<UITextFieldDelegate>
{
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddLocationTextView
@synthesize textField;
@synthesize delegate;


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)txtDidEnd
{
    if ([self.delegate respondsToSelector:@selector(addPlace:)]) {
        [self.delegate addPlace:textField.text];
    }
}

- (void)dismiss
{
    //[textField resignFirstResponder];
    [self setHidden:YES];
}

- (void)show
{
    textField.text = nil;
    [textField becomeFirstResponder];
    [self setHidden:NO];
}

- (void)configUI
{
    [textField addTarget:self action:@selector(txtDidEnd) forControlEvents:UIControlEventEditingDidEndOnExit];
}

+(AddLocationTextView *)createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddLocationTextView" owner:self options:nil];
    AddLocationTextView * view = (AddLocationTextView*)[nibView objectAtIndex:0];
    [view configUI];
    return view;
}

@end
