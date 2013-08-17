//
//  EventDetailCommentView.m
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailCommentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHeaderPhoto:(UIImage *)photo
{
    [_commentAutherPhotoView setImage:photo];
}

- (void)updateUI
{
    [_commentAutherPhotoView setClipsToBounds:YES];
    [_commentAutherPhotoView.layer setCornerRadius:_commentAutherPhotoView.frame.size.width / 2];
    
    [_commentAutherPhotoView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [_commentAutherPhotoView.layer setShadowRadius:3.0f];
    [_commentAutherPhotoView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [_commentAutherPhotoView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [_commentAutherPhotoView.layer setBorderWidth:1.0f];
    
}

+(EventDetailCommentView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentView" owner:self options:nil];
    EventDetailCommentView * view = (EventDetailCommentView*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}

- (void)dealloc {
    [_commentAutherPhotoView release];
    [_commentContentLabel release];
    [_commentTimeLabel release];
    [super dealloc];
}
@end
