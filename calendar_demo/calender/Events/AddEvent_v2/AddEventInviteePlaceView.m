//
//  AddEventInviteePlaceView.m
//  Calvin
//
//  Created by zyax86 on 1/18/14.
//  Copyright (c) 2014 fang xiang. All rights reserved.
//
#import "AddEventInviteePlaceView.h"

@interface AddEventInviteePlaceView()
{
    UIImageView *arrawImage;
}

@end

@implementation AddEventInviteePlaceView

- (id)initByCreator:(BOOL)creator CanChangeLocation:(BOOL)canChangeLocation
{
    self = [super initByCreator:creator CanChangeLocation:canChangeLocation];
    [self updateUI];
    [self addBgView];
    
    self.backgroundColor = [UIColor clearColor];
    
    arrawImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_event_arraw_v2.png"]];
    
    [arrawImage setFrame:CGRectMake(0, 0, 6, 10)];
    [arrawImage setCenter:CGPointMake(303, self.inviteeView.frame.size.height / 2)];
    [self addSubview:arrawImage];
    [arrawImage setHidden:YES];
    
    
    return self;
}

- (void)setLocationMode
{
    
    [verSep setHidden:YES];
    [self.inviteeView setHidden:YES];
    [self.placeView setHidden:NO];
    
    CGRect frame = self.placeView.frame;
    frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
    self.placeView.frame = frame;
    
    [arrawImage setHidden:NO];
}

- (void)setInviteesMode
{
    [verSep setHidden:YES];
    
    [self.inviteeView.arrawView setHidden:YES];
    [self.inviteeView setHidden:NO];
    [self.placeView setHidden:YES];
    
    CGRect frame = self.inviteeView.frame;
    frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
    self.inviteeView.frame = frame;
    [arrawImage setHidden:NO];
}

- (void)setInviteesAndLocationMode
{
    [verSep setHidden:NO];
    
    [self.inviteeView.arrawView setHidden:NO];
    [self.inviteeView setHidden:NO];
    [self.placeView setHidden:NO];
    
    CGRect frame = self.inviteeView.frame;
    frame.origin.x = 5;
    frame.origin.y = 8;
    self.inviteeView.frame = frame;
    
    frame = self.placeView.frame;
    frame.origin.x = 5 * 2 + self.inviteeView.frame.size.width;
    frame.origin.y = 8;
    self.placeView.frame = frame;
    
    [arrawImage setHidden:YES];
}


-(void) singleTapLocation:(UITapGestureRecognizer*) tap
{
    LOG_D(@"singleTapLocation");
    
    [self.delegate changeLocation];
}
@end
