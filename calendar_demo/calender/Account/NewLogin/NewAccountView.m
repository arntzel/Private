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
#import "SettingsModel.h"

#define KEYBOARD_OFFSET 100;

@implementation NewAccountView
{
    UITapGestureRecognizer *tapGesture;
    SettingsModel * settingModel;
}

@synthesize delegate;

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
    settingModel = [[SettingsModel alloc] init];
    UIColor *textBgColor = [UIColor colorWithRed:223.0/255.0 green:237.0/255.0 blue:232.0/255.0 alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.profileView setBackgroundColor:textBgColor];
    [self.infoView setBackgroundColor:textBgColor];
    
    [self.avatar setUserInteractionEnabled:YES];
    [self.avatar setClipsToBounds:YES];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotoTap)];
    [self.avatar addGestureRecognizer:tapGesture];
    
    [self.firstName setBorderStyle:UITextBorderStyleNone];
    [self.firstName setBackgroundColor:[UIColor clearColor]];
    self.firstName.placeholder = @"First Name";
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.firstName.returnKeyType = UIReturnKeyNext;
    self.firstName.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.firstName setFont:font];
    
    [self.lastName setBorderStyle:UITextBorderStyleNone];
    [self.lastName setBackgroundColor:[UIColor clearColor]];
    self.lastName.placeholder = @"Last Name";
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.lastName.returnKeyType = UIReturnKeyNext;
    self.lastName.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.lastName setFont:font];
    
    [self.zipCode setBorderStyle:UITextBorderStyleNone];
    [self.zipCode setBackgroundColor:[UIColor clearColor]];
    self.zipCode.placeholder = @"Zip Code";
    self.zipCode.autocorrectionType = UITextAutocorrectionTypeNo;
    self.zipCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.zipCode.returnKeyType = UIReturnKeyNext;
    self.zipCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.zipCode setFont:font];
    
    CALayer *lay  = self.avatar.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:35.0];
    [lay setBorderWidth:1];
    [lay setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.email.delegate = self;
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.email setBackgroundColor:[UIColor clearColor]];
    self.email.placeholder = @"Email Address";
    self.email.autocorrectionType = UITextAutocorrectionTypeNo;
    self.email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.email.returnKeyType = UIReturnKeyNext;
    self.email.keyboardType = UIKeyboardTypeEmailAddress;
    [self.email setFont:font];
    
    self.password.delegate = self;
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.password setBackgroundColor:[UIColor clearColor]];
    self.password.secureTextEntry = YES;
    self.password.placeholder = @"Password";
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.returnKeyType = UIReturnKeyNext;
    [self.password setFont:font];
    
    self.confirmPassword.delegate = self;
    [self.confirmPassword setBorderStyle:UITextBorderStyleNone];
    [self.confirmPassword setBackgroundColor:[UIColor clearColor]];
    self.confirmPassword.secureTextEntry = YES;
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

+(NewAccountView *) createWithDelegate:(UIViewController<NewAccountViewDelegate> *) theDelegate;
{
    NewAccountView *view =(NewAccountView *)[ViewUtils createView:@"NewAccountView"];
    view.delegate = theDelegate;
    return view;
}

#pragma mark Add Photo
- (void)addPhotoTap
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Picker Photo From Album" otherButtonTitles:@"Picker Photo From Camera", nil];
    [menu showInView:self];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self getImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if(buttonIndex == 1)
    {
        [self getImageFrom:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)getImageFrom:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self.delegate presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    CGSize targetSize = self.avatar.frame.size;
    targetSize.height = 300;
    targetSize.width = 300;
    
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    self.avatar.image = newImage;
    self.avatar.alpha = 0.5;
    [self uploadImage:newImage];
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) uploadImage:(UIImage *) img
{
    if(self.imageUrl != nil) {
        self.imageUrl = nil;
    }
    
    self.avatar.alpha = 0.3;
    
    [settingModel updateAvatar:img andCallback:^(NSInteger error, NSString *url) {
        [self onUploadCompleted:error andUrl:url];
    }];
}

//-(void) onUploadStart
//{
//
//}
//
//-(void) onUploadProgress: (long long) progress andSize: (long long) Size
//{
//    float prg = (float)progress / (float)Size;
//    self.imageViewAddPhoto.alpha = 0.3 + prg*0.7;
//    LOG_D(@"onUploadProgress: progress=%f", prg);
//}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted: url=%@", url);
    
    self.avatar.alpha = 1;
    
    if(error == 0) {
        self.imageUrl = url;
    } else {
        self.avatar.image = nil;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect frame = textField.frame;
    //int offset = frame.origin.y + 32 - (self.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    int offset = -KEYBOARD_OFFSET;
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.90f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    int offset = KEYBOARD_OFFSET;
    self.frame = CGRectMake(0.0f, offset, self.frame.size.width, self.frame.size.height);
    
    [UIView commitAnimations];
}

@end
