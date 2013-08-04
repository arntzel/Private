//
//  EventDetailPhotoView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPhotoView.h"
#import "DKLiveBlurView.h"

@implementation EventDetailPhotoView


- (void)updateUI
{
    DKLiveBlurView *blurView = [[DKLiveBlurView alloc] initWithFrame:self.photoView.frame];
    [_photoView removeFromSuperview];
    [_photoView release];
    
    self.photoView = blurView;
    [self insertSubview:blurView belowSubview:_titleLabel];
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
    [_photoView release];
    [_titleLabel release];
    [super dealloc];
}


+(EventDetailPhotoView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPhotoView" owner:self options:nil];
    EventDetailPhotoView * view = (EventDetailPhotoView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

@end
