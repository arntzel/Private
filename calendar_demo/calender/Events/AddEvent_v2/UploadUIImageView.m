//
//  UploadUIImageView.m
//  Calvin
//
//  Created by fangxiang on 14-1-19.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "UploadUIImageView.h"
#import "ASIFormDataRequest.h"
#import "ViewUtils.h"
#import "Model.h"

@interface UploadUIImageView() < UINavigationControllerDelegate,
                                 UIImagePickerControllerDelegate,
                                 UIActionSheetDelegate,
                                 UploadImageDelegate>

@end

@implementation UploadUIImageView {
    
   
    //For preupload Image
    ASIFormDataRequest * request;
    UIActivityIndicatorView * imageUploadingIndicator;
    
    UIProgressView * progressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imagePickerView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imagePickerView setUserInteractionEnabled:YES];
        [self addSubview:self.imagePickerView];
        
        [self.imagePickerView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imagePickerView setClipsToBounds:YES];
        
        UIImageView *maskImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        maskImageView.image = [UIImage imageNamed:@"shadow_ovlerlay_asset.png"];
        [self addSubview:maskImageView];
        
        
        UIImageView *imagePickerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imagePickerIcon"]];
        imagePickerIcon.center = self.center;
        //CGRect frame = imagePickerIcon.frame;
        //frame.size.width/=2;
        //frame.size.height/=2;
        //imagePickerIcon.frame = frame;
        //imagePickerIcon.center = self.center;
        [self addSubview:imagePickerIcon];
        
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedInImagePickerView:)];
        [self.imagePickerView addGestureRecognizer:gesture];
        
        progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-10, 280, 20)];
        [progressView setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
        progressView.hidden = YES;
        [self addSubview:progressView];
        
        imageUploadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        imageUploadingIndicator.hidesWhenStopped = YES;
        imageUploadingIndicator.center = CGPointMake(20, 70);
        [self addSubview:imageUploadingIndicator];
        
    }
    return self;
}

-(void) dealloc
{
    if(request != nil) {
        [request cancel];
        request  = nil;
    }
}

-(void) touchedInImagePickerView:(UITapGestureRecognizer *) tap
{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Choose Existing", @"Take Photo", nil];
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
    
    [self.controller presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    CGSize targetSize = self.imagePickerView.frame.size;
    targetSize.height *= 2;
    targetSize.width *= 2;
    
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    self.imagePickerView.image = newImage;
    [picker dismissModalViewControllerAnimated:YES];
    
    [self uploadImage];
}

-(void) uploadImage
{
    if(request != nil)
    {
        [request cancel];
        request = nil;
    }
    
    self.uploadImageUrl = nil;
    
    UIImage * img = self.imagePickerView.image;
    [imageUploadingIndicator startAnimating];

    request = [[Model getInstance] uploadImage:img andCallback:self];
}

-(void) onUploadStart
{
    progressView.hidden = NO;
}

-(void) onUploadProgress: (long long) progress andSize: (long long) Size
{
    LOG_D(@"onUploadProgress");
    float progressVal = (progress*1.0)/Size;
    
    if(progressVal>1) progressVal = 1;
    
    progressView.progress = progressVal;
   
}

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url
{
    LOG_D(@"onUploadCompleted");
    [imageUploadingIndicator stopAnimating];
    progressView.hidden = YES;
    
    request = nil;
    
    if(error != 0) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"Upload Image failed."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        self.imagePickerView.image = nil;
        
    } else {
        LOG_D(@"onUploadCompleted:%@", url);
        self.uploadImageUrl = url;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
