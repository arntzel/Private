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

@interface EventDetailInviteePlaceView()<UIActionSheetDelegate>
{
    BOOL isCreator;
    BOOL showAllDescitpion;
}

@property(retain, nonatomic) EventDetailInviteeView *inviteeView;
@property(retain, nonatomic) EventDetailPlaceView *placeView;
@property(retain, nonatomic) UILabel * desciptionView;

@property(retain, nonatomic) UIActionSheet *placeActionSheet;
@property(retain, nonatomic) UIActionSheet *descriptionActionSheet;

@end

@implementation EventDetailInviteePlaceView
@synthesize delegate;
@synthesize placeActionSheet;
@synthesize descriptionActionSheet;

- (id)initByCreator:(BOOL)creator;
{
    return [self initWithFrame:CGRectZero ByCreator:creator];
}

- (void)dealloc
{
    self.descriptionActionSheet.delegate = nil;
    self.descriptionActionSheet = nil;
    self.placeActionSheet.delegate = nil;
    self.placeActionSheet = nil;
    
    self.inviteeView = nil;
    self.placeView = nil;
    self.desciptionView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame ByCreator:(BOOL)creator;
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
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapLocation:)];
        [self.placeView addGestureRecognizer:gesture];
        [gesture release];
        
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInvitees:)];
        [self.inviteeView addGestureRecognizer:gesture];
        [gesture release];
        
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDescitpion:)];
        [self.desciptionView addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
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

-(void) addDescriptionView {
    self.desciptionView = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.desciptionView setFont:[UIFont systemFontOfSize:14]];
    self.desciptionView.backgroundColor = [UIColor clearColor];
    self.desciptionView.userInteractionEnabled = YES;
    [self.desciptionView setLineBreakMode:UILineBreakModeTailTruncation];
    
    [self addSubview:self.desciptionView];
    
    [self.desciptionView release];
}

-(void) singleTapLocation:(UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapLocation");
    if(isCreator)
    {
        self.placeActionSheet = [[[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                                  otherButtonTitles:@"Change Location", @"View in Maps", nil] autorelease];
    }
    else
    {
        self.placeActionSheet = [[[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                                  otherButtonTitles:@"View in Maps", nil] autorelease];
    }
    
    [placeActionSheet showInView:self];
}

- (void)placeActionSheetClick:(NSInteger)index
{
    if(isCreator)
    {
        if(index == 0) {
            if ([self.delegate respondsToSelector:@selector(changeLocation)]) {
                [self.delegate changeLocation];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(viewInMaps)]) {
                [self.delegate viewInMaps];
            }
        }
    }
    else if(index == 0)
    {
        if ([self.delegate respondsToSelector:@selector(viewInMaps)]) {
            [self.delegate viewInMaps];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LOG_D(@"actionSheet:clickedButtonAtIndex:tag=%d, buttonindex=%d", actionSheet.tag, buttonIndex);
    if (actionSheet == placeActionSheet) {
        [self placeActionSheetClick:buttonIndex];
    }
    else if (actionSheet == descriptionActionSheet)
    {
        
    }
}

-(void) singleTapInvitees: (UITapGestureRecognizer*) tap
{
    
}

-(void) singleTapDescitpion: (UITapGestureRecognizer*) tap
{
    [UIView animateWithDuration:0.3f animations:^{
        [self toggleDesciptionView];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(frameDidChanged)]) {
            [self.delegate frameDidChanged];
        }
    }];
}

- (void) setDesciption:(NSString *) desc
{
    self.desciptionView.text = desc;
    [self updateFrame];
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

- (void)updateInvitee:(NSArray *) users
{
    [self.inviteeView updateInvitee:users];
}

- (void) setLocation:(Location*) location
{
    [self.placeView setLocation:location];
}

- (void)updateUI
{
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];

    [self updateFrame];
}

- (void)updateFrame
{
    [self updateDescriptionFrame];
    
    CGRect viewFrame = self.frame;
    viewFrame.size.width = 320;
    viewFrame.size.height =  self.desciptionView.frame.origin.y + self.desciptionView.frame.size.height + 8 + 14;
    self.frame = viewFrame;
}

-(void) updateDescriptionFrame
{
    int y = self.inviteeView.frame.origin.y + self.inviteeView.frame.size.height;
    y += 10;
    
    if(showAllDescitpion) {
        [self.desciptionView setNumberOfLines:0];
    } else {
        [self.desciptionView setNumberOfLines:3];
    }
    
    int lines = showAllDescitpion?0:3;
    CGRect rect = [self.desciptionView textRectForBounds:CGRectMake(0, 0, 310, 500) limitedToNumberOfLines:lines];
    
    CGSize size = rect.size;
    [self.desciptionView setFrame:CGRectMake(5, y, size.width, size.height)];
}

@end
