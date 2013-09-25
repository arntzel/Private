//
//  LoginMainCreatView.m
//  login
//
//  Created by zyax86 on 9/23/13.
//  Copyright (c) 2013 zyax86. All rights reserved.
//

#import "LoginMainCreatView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewUtils.h"

@interface LoginMainCreatView()<UIActionSheetDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
{
    BOOL isHeadPhotoAdded;
    UITapGestureRecognizer *tapGesture;
}

@property (weak, nonatomic) IBOutlet UITextField *textFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textLastName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAddPhoto;

@end

@implementation LoginMainCreatView
@synthesize delegate;

- (void)dealloc
{
    [self.imageViewAddPhoto removeGestureRecognizer:tapGesture];
}

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

- (IBAction)btnSignUpClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(btnSignUpDidClickWithName:Email:Password:HeadPhoto:)]) {
        NSString *userName = [NSString stringWithFormat:@"%@%@",self.textFirstName.text,self.textLastName.text];
        UIImage *headPhoto = nil;
        if (isHeadPhotoAdded) {
            headPhoto = self.imageViewAddPhoto.image;
        }
        [self.delegate btnSignUpDidClickWithName:userName Email:self.textEmail.text Password:self.textPassword.text HeadPhoto:headPhoto];
    }
}

- (void)updateUI
{
    UIColor *bordColor = [UIColor colorWithRed:134.0/255.0f green:134.0/255.0f blue:134.0/255.0f alpha:1.0f];
    [self.imageViewAddPhoto.layer setBorderColor:bordColor.CGColor];
    UIColor *bgColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:0.34f];
    self.imageViewAddPhoto.backgroundColor = bgColor;
    [self.imageViewAddPhoto.layer setCornerRadius:self.imageViewAddPhoto.frame.size.width / 2];
    [self.imageViewAddPhoto.layer setBorderWidth:2.0f];
    self.imageViewAddPhoto.image = [UIImage imageNamed:@"login_main_singnup_addphoto.png"];
    
    [self.imageViewAddPhoto setUserInteractionEnabled:YES];
    [self.imageViewAddPhoto setClipsToBounds:YES];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhotoTap)];
    [self.imageViewAddPhoto addGestureRecognizer:tapGesture];
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
    [self.delegate presentModalViewController:ipc animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    CGSize targetSize = self.imageViewAddPhoto.frame.size;
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    self.imageViewAddPhoto.image = newImage;
    [picker dismissModalViewControllerAnimated:YES];
    
    isHeadPhotoAdded = YES;
}


+(LoginMainCreatView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainCreatView" owner:self options:nil];
    LoginMainCreatView * view = (LoginMainCreatView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
