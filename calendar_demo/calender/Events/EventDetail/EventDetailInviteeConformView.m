//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeConformView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailInviteeConformView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)dealloc {
    [_tickedBtn release];
    [_crossedbtn release];
    [_contentView release];

    self.eventTimeLabel = nil;
    self.eventTimeConflictLabel = nil;
    [super dealloc];
}

- (void)updateUI
{
    [self.contentView.layer setCornerRadius:5.0f];
    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
}

- (IBAction)tickBtnClick:(id)sender {
    if (!self.tickedBtn.selected) {
        self.tickedBtn.selected = YES;
        self.crossedbtn.selected = NO;
    }
}

- (IBAction)crossBtnClick:(id)sender {
    if (!self.crossedbtn.selected) {
        self.tickedBtn.selected = NO;
        self.crossedbtn.selected = YES;
    }
}


- (void)setTicked
{
    [self.tickedBtn setSelected:YES];
    [self.crossedbtn setSelected:NO];
}


- (void)setCrossed
{
    [self.tickedBtn setSelected:NO];
    [self.crossedbtn setSelected:YES];
}


+(EventDetailInviteeConformView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailInviteeConformView" owner:self options:nil];
    EventDetailInviteeConformView * view = (EventDetailInviteeConformView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}
@end
