//
//  EventDetailInviteePlaceView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteePlaceView.h"
#import "EventDetailInviteeView.h"
#import "EventDetailPlaceView.h"
#import <QuartzCore/QuartzCore.h>

@interface EventDetailInviteePlaceView()
{
    EventDetailInviteeView *inviteeView;
    EventDetailPlaceView *placeView;
}

@end

@implementation EventDetailInviteePlaceView

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0f]];

        [self addInviteeView];
        [self addPlaceView];
        
        [self updateUI];
    }
    return self;
}

- (void)updateUI
{
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
    
    CGRect viewFrame = self.frame;
    viewFrame.size.width = 320;
    viewFrame.size.height = inviteeView.frame.size.height + 8 + 14;
    self.frame = viewFrame;
}

- (void)addInviteeView
{
    inviteeView = [[EventDetailInviteeView creatView] retain];
    
    CGRect frame = inviteeView.frame;
    frame.origin.x = 5;
    frame.origin.y = 8;
    inviteeView.frame = frame;
    
    [self addSubview:inviteeView];
}

- (void)addPlaceView
{
    placeView = [[EventDetailPlaceView creatView] retain];
    
    CGRect frame = placeView.frame;
    frame.origin.x = 5 * 2 + inviteeView.frame.size.width;
    frame.origin.y = 8;
    placeView.frame = frame;
    
    [self addSubview:placeView];
}

- (void)dealloc
{
    [inviteeView release];
    [placeView release];
    
    [super dealloc];
}



@end
