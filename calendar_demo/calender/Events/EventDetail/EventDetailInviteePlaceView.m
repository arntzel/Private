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
    BOOL canChangePlace;
    BOOL showAllDescitpion;
}

@property(retain, nonatomic) EventDetailInviteeView *inviteeView;
@property(retain, nonatomic) EventDetailPlaceView *placeView;
@property(retain, nonatomic) UILabel * desciptionView;

@property(retain, nonatomic) NSMutableArray * actionSheetButtonTitles;

@end

@implementation EventDetailInviteePlaceView
@synthesize delegate;
@synthesize actionSheetButtonTitles;

- (id)initByCreator:(BOOL)creator CanChangeLocation:(BOOL)canChangeLocation
{
    return [self initWithFrame:CGRectZero ByCreator:creator CanChangeLocation:canChangeLocation];
}

- (void)dealloc
{
    self.actionSheetButtonTitles = nil;
    
    self.inviteeView = nil;
    self.placeView = nil;
    self.desciptionView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame ByCreator:(BOOL)creator CanChangeLocation:(BOOL)canChangeLocation
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1.0f]];

        isCreator = creator;
        canChangePlace = canChangeLocation;
        showAllDescitpion = NO;
        
        
        

        
        [self addInviteeView];
        [self addPlaceView];

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

    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapInvitees:)];
    [self.inviteeView addGestureRecognizer:gesture];
    [gesture release];
}

- (void)addPlaceView
{
    self.placeView = [EventDetailPlaceView creatView];
    [self.placeView addMask:isCreator];
    
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
    [self.desciptionView setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [self addSubview:self.desciptionView];
    
    [self.desciptionView release];
}

-(void) singleTapLocation:(UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapLocation");
    
    actionSheetButtonTitles = [[NSMutableArray alloc] init];
    if(isCreator || canChangePlace) {
        [actionSheetButtonTitles addObject:@"Change Location"];
    }
    
    if([self.placeView haveLocation]) {
        [actionSheetButtonTitles addObject:@"View in Maps"];
    }
    
    
    if(actionSheetButtonTitles.count == 0) return;
    
    [actionSheetButtonTitles addObject:@"Cancel"];
    
    UIActionSheet * placeActionSheet = [[[UIActionSheet alloc]
                              initWithTitle:nil
                              delegate:self
                              cancelButtonTitle:nil
                              destructiveButtonTitle:nil
                              otherButtonTitles:nil] autorelease];

    for(NSString * title in actionSheetButtonTitles) {
        [placeActionSheet addButtonWithTitle:title];
    }
    
    placeActionSheet.cancelButtonIndex = placeActionSheet.numberOfButtons -1;
    
    [placeActionSheet showInView:self];
    
}

- (void)placeActionSheetClick:(NSInteger)index
{

    
    NSString * title = [actionSheetButtonTitles objectAtIndex:index];
    
    if([@"Cancel" isEqualToString:title]) {
        //Do nothing
    } else if([@"Change Location" isEqualToString:title]) {
        
        [self.delegate changeLocation];
        
    } else if([@"View in Maps" isEqualToString:title]) {
        
        [self.delegate viewInMaps];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LOG_D(@"actionSheet:clickedButtonAtIndex:tag=%d, buttonindex=%d", actionSheet.tag, buttonIndex);
    [self placeActionSheetClick:buttonIndex];
}

-(void) singleTapInvitees: (UITapGestureRecognizer*) tap
{
    if ([self.delegate respondsToSelector:@selector(onInviteeViewClicked)]) {
        [self.delegate onInviteeViewClicked];
    }
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
        [self.desciptionView setNumberOfLines:5];
    }
    
    int lines = showAllDescitpion ? 0 : 5;
    CGRect rect = [self.desciptionView textRectForBounds:CGRectMake(0, 0, 304, 1000) limitedToNumberOfLines:lines];
    
    CGSize size = rect.size;
    [self.desciptionView setFrame:CGRectMake(8, y, size.width, size.height)];
}

@end
