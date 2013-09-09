//
//  EventDetailCommentTextView.m
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import "EventDetailCommentTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailCommentTextView

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
    [_autherPhotoView setImage:photo];
}

- (void)updateUI
{
    [_autherPhotoView setClipsToBounds:YES];
    [_autherPhotoView.layer setCornerRadius:_autherPhotoView.frame.size.width / 2];
    
    [_autherPhotoView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [_autherPhotoView.layer setShadowRadius:3.0f];
    [_autherPhotoView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [_autherPhotoView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [_autherPhotoView.layer setBorderWidth:1.0f];
    

    
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
    
    [self.messageField addTarget:self action:@selector(keydone) forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void) keydone
{
    [self.messageField resignFirstResponder];
}

+(EventDetailCommentTextView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailCommentTextView" owner:self options:nil];
    EventDetailCommentTextView * view = (EventDetailCommentTextView*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}

@end
