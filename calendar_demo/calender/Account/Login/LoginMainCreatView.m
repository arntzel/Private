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
#import "Utils.h"
#import "Model.h"
#import "CreateUser.h"
#import "SettingsModel.h"

@interface LoginMainCreatView()<UIActionSheetDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
{
    UITapGestureRecognizer *tapGesture;
    NSString * imageUrl;
}

@property (weak, nonatomic) IBOutlet UITextField *textFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textLastName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAddPhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation LoginMainCreatView {
    SettingsModel * settingModel;
}

@synthesize delegate;

- (void)dealloc
{
    [self.imageViewAddPhoto removeGestureRecognizer:tapGesture];
    imageUrl = nil;
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
    
    if( ![Utils isValidateEmail:self.textEmail.text]) {
        [Utils showUIAlertView:@"" andMessage:@"Email is invalided!"];
        return;
    }
    
    if( self.textPassword.text == nil || self.textPassword.text.length ==0) {
        [Utils showUIAlertView:@"" andMessage:@"Password is empty!"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(btnSignUpDidClickWithName:)]) {
        
        CreateUser * createUser = [[CreateUser alloc] init];
        createUser.first_name = self.textFirstName.text;
        createUser.last_name = self.textLastName.text;
        createUser.avatar_url = imageUrl;
        createUser.email = self.textEmail.text;
        createUser.username = createUser.email;
        createUser.password = self.textPassword.text;
        
        [self.delegate btnSignUpDidClickWithName:createUser];
    }
}

-(void) showLoadingAnimation:(BOOL)show
{
    self.indicator.hidden = !show;
}

- (void)updateUI
{

    [self.textEmail addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
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

    settingModel = [[SettingsModel alloc] init];
}

- (void) textFieldDidChange:(UITextField *) TextField
{
//    if ([Utils isValidateEmail:TextField.text]) {
//        TextField.textColor = [UIColor blackColor];
//    } else {
//        TextField.textColor = [UIColor redColor];
//    }
    
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
    
    CGSize targetSize = self.imageViewAddPhoto.frame.size;
    targetSize.height = 300;
    targetSize.width = 300;
    
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    self.imageViewAddPhoto.image = newImage;
    self.imageViewAddPhoto.alpha = 0.5;
    [self uploadImage:newImage];
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) uploadImage:(UIImage *) img
{
    if(imageUrl != nil) {
        imageUrl = nil;
    }

    self.imageViewAddPhoto.alpha = 0.3;

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
    
    self.imageViewAddPhoto.alpha = 1;
    
    if(error == 0) {
        imageUrl = url;
    } else {
        self.imageViewAddPhoto.image = nil;
    }
}


+(LoginMainCreatView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginMainCreatView" owner:self options:nil];
    LoginMainCreatView * view = (LoginMainCreatView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}



@end
