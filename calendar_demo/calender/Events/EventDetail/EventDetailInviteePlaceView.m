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


@implementation EventDetailInviteePlaceView {
    BOOL showAllDescitpion;
}

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
        showAllDescitpion = NO;
        [self addDescriptionView];
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

    [self updateDescriptionFrame];
    
    CGRect viewFrame = self.frame;
    viewFrame.size.width = 320;
    viewFrame.size.height =  self.desciptionView.frame.origin.y + self.desciptionView.frame.size.height + 10;
    self.frame = viewFrame;
}

- (void) showDesciption:(BOOL) all
{
    showAllDescitpion = all;

    [self updateUI];
}

- (void) toggleDesciptionView
{
    [self showDesciption:!showAllDescitpion];
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

-(void) addDescriptionView {

        
    self.desciptionView = [[UILabel alloc] initWithFrame:CGRectZero];

    [self.desciptionView setFont:[UIFont systemFontOfSize:14]];
    self.desciptionView.backgroundColor = [UIColor clearColor];
    self.desciptionView.userInteractionEnabled = YES;
    [self.desciptionView setLineBreakMode:UILineBreakModeTailTruncation];
    
    [self addSubview:self.desciptionView];

    [self.desciptionView release];
}

- (void) setDesciption:(NSString *) desc
{
    self.desciptionView.text = desc;
    [self updateUI];
}

-(void) updateDescriptionFrame
{
    int y = self.inviteeView.frame.origin.y + self.inviteeView.frame.size.height;
    y += 10;
    
    if(showAllDescitpion) {
        [self.desciptionView setNumberOfLines:0];
    } else {
        [self.desciptionView setNumberOfLines:5];
    }
    
    int lines = showAllDescitpion ? 0 : 5;
    CGRect rect = [self.desciptionView textRectForBounds:CGRectMake(0, 0, 304, 1000) limitedToNumberOfLines:lines];
    
    CGSize size = rect.size;
    //CGSize size = [str sizeWithFont:self.desciptionView.font constrainedToSize:CGSizeMake(310, 500) lineBreakMode:UILineBreakModeCharacterWrap];
    [self.desciptionView setFrame:CGRectMake(8, y, size.width, size.height)];
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
    self.desciptionView = nil;
    [super dealloc];
}

@end
