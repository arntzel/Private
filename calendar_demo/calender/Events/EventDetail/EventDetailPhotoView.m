//
//  EventDetailPhotoView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPhotoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewUtils.h"

@interface EventDetailPhotoView()<UIActionSheetDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@end

@implementation EventDetailPhotoView
{
    UIView *navBar;
    UIScrollView *scrollView;
    CGFloat orgHeight;
    CGFloat scrollScope;
}

@synthesize controller;

- (void)updateUI
{
    DKLiveBlurView *blurView = [[DKLiveBlurView alloc] initWithFrame:self.frame];
    blurView.isGlassEffectOn = YES;
    [_photoView removeFromSuperview];
    [_photoView release];
    
    self.photoView = blurView;
    
    [_titleLabel setShadowColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:.4f]];
    [self insertSubview:blurView belowSubview:_titleLabel];
    
    [_subTitle setShadowColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:.4f]];
    
    [blurView release];

    orgHeight = self.frame.size.height;
    self.clipsToBounds = YES;
}

- (void)addCreatorAction
{
    self.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPhotoView:)];
    [self.photoView addGestureRecognizer:gesture];
    [gesture release];
}



#pragma mark Add Photo
-(void) singleTapPhotoView:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:nil
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                   otherButtonTitles:@"Add from Camera Roll", @"Use Facebook Cover Photo", @"Take Photo", nil];
    [actionSheet showInView:self];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self getImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if(buttonIndex ==1) {

        //user facebook

    } else if(buttonIndex == 2) {
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
    
    CGSize targetSize = self.photoView.frame.size;
    targetSize.height*=2;
    targetSize.width*=2;
    
    UIImage * newImage = [ViewUtils imageByScalingAndCroppingForSize:targetSize andUIImage:image];
    
    [self setImage:newImage];
    if ([self.controller respondsToSelector:@selector(detailPhotoDidChanged:)]) {
        [self.controller detailPhotoDidChanged:newImage];
    }
    [picker dismissModalViewControllerAnimated:YES];
}


- (void)setImage:(UIImage *)image
{
    [self.photoView setOriginalImage:image];
}

- (UIImage *)getImage
{
    return self.photoView.originalImage;
}

- (void)setDefaultImage
{
    [self setImage:[self getRandomPhoto]];
}

-(UIImage *) getRandomPhoto
{
    //event_detail_random_header1.png
    int value = (arc4random() % 8) + 1;
    
    NSString * name = [NSString stringWithFormat:@"event_detail_random_header%d.png", value];
    UIImage * img = [UIImage imageNamed:name];
    return img;
}

-(void) setImageUrl:(NSString *) imageUrl
{
    if(imageUrl != nil) {
        UIImage * img = self.photoView.image;
        //[self.photoView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:img];
        
        [self.photoView setImageWithURL:[NSURL URLWithString:imageUrl]  placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [self setImage:image];
        }];
    }
}

- (void)setScrollView:(UIScrollView *)_scrollView
{
    [scrollView removeObserver:self forKeyPath: @"contentOffset"];
    
    scrollView = nil;
    scrollView = _scrollView;
    self.photoView.scrollView = _scrollView;
    
    if (scrollView)
    {
        [scrollView addObserver:self forKeyPath: @"contentOffset" options: 0 context: nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context{
    
    CGFloat scrollOffsetY = scrollView.contentOffset.y;

    CGRect frame = self.frame;
    frame.size.height = orgHeight - scrollOffsetY;
    if(frame.size.height < navBar.frame.size.height) {
        frame.size.height = navBar.frame.size.height;
    }
    self.frame = frame;
    
    if (scrollOffsetY > scrollScope) {
        scrollOffsetY = scrollScope;
    }
    
    [self.titleLabel setCenter:CGPointMake(self.titleLabel.center.x, navBar.frame.size.height / 2 + (scrollScope - scrollOffsetY) - 15)];
    
    [self.subTitle setCenter:CGPointMake(self.subTitle.center.x, navBar.frame.size.height / 2 + (scrollScope - scrollOffsetY) + 20 - 15)];
    
    CGSize maxSize = CGSizeMake(1000.0f, self.subTitle.frame.size.height);
    CGSize fontSize = [self.subTitle.text sizeWithFont:self.subTitle.font constrainedToSize:maxSize lineBreakMode:self.subTitle.lineBreakMode];
    
    
    [self.finalizedImg setCenter:CGPointMake(160 - fontSize.width/2 - 12, navBar.frame.size.height / 2 + (scrollScope - scrollOffsetY) + 20 - 15)];


    //NSLog(@"%f, %f", self.titleLabel.center.x, self.titleLabel.center.y);

    CGFloat maxFont = 20;
    CGFloat minFont = 13;
    
    CGFloat fontRadio = 1 - (scrollScope - scrollOffsetY) / scrollScope;
    
    CGFloat currentFont = maxFont - (maxFont - minFont) * fontRadio;
    
    //[self.titleLabel setFont:[UIFont systemFontOfSize:currentFont]];
    UIFont *titleLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:currentFont];
    [self.titleLabel setFont:titleLabelFont];
}

- (void)setNavgation:(UIView *)navigation
{
    navBar = nil;
    navBar = navigation;
    scrollScope = orgHeight - navBar.frame.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    self.controller = nil;
    [_photoView release];
    [_titleLabel release];
    [super dealloc];
}


+(EventDetailPhotoView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPhotoView" owner:self options:nil];
    EventDetailPhotoView * view = (EventDetailPhotoView*)[nibView objectAtIndex:0];
    view.isFinalized = NO;
    [view updateUI];
    return view;
}

@end
