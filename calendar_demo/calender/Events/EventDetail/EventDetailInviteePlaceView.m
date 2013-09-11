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
    viewFrame.size.height = self.inviteeView.frame.size.height + 8 + 14;
    self.frame = viewFrame;
}

- (void)addInviteeView
{
    self.inviteeView = [EventDetailInviteeView creatView];
    
    CGRect frame = self.inviteeView.frame;
    frame.origin.x = 5;
    frame.origin.y = 8;
    self.inviteeView.frame = frame;
    
    [self addSubview:self.inviteeView];
}

- (void)addPlaceView
{
    self.placeView = [EventDetailPlaceView creatView];
    
    CGRect frame = self.placeView.frame;
    frame.origin.x = 5 * 2 + self.inviteeView.frame.size.width;
    frame.origin.y = 8;
    self.placeView.frame = frame;
    
    [self addSubview:self.placeView];
}

- (void)dealloc
{
    self.inviteeView = nil;
    self.placeView = nil;
    
    [super dealloc];
}



@end
