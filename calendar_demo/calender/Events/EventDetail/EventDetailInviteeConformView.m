//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeConformView.h"
#import <QuartzCore/QuartzCore.h>


@interface EventDetailInviteeConformView()



@end

@implementation EventDetailInviteeConformView {
    int _vote;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTime:(NSString *)time
{
    self.eventTimeLabel.text = time;
    self.eventTimeLabel.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.eventTimeLabel.attributedText];
    self.eventTimeLabel.centerVertically = YES;
}

- (void)setConflictCount:(NSInteger)count
{
    if (count > 0) {
        self.eventTimeConflictLabel.text = [NSString stringWithFormat:@"%d CONFLICT", count];
        [self.eventTimeConflictLabel setHidden:NO];
        [self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, 20)];
    }
    else
    {
        [self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, self.frame.size.height / 2)];
        [self.eventTimeConflictLabel setHidden:YES];
    }
    
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
//    if (!self.tickedBtn.selected) {
//        self.tickedBtn.selected = YES;
//        self.crossedbtn.selected = NO;
//    }
}

- (IBAction)crossBtnClick:(id)sender {
//    if (!self.crossedbtn.selected) {
//        self.tickedBtn.selected = NO;
//        self.crossedbtn.selected = YES;
//    }
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

-(void) setVoteStatus:(int) vote
{
    _vote = vote;
    
    switch (vote) {
        case 0:
            [self.tickedBtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_tick_black.png"] forState:UIControlStateNormal];
            [self.crossedbtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_cross_black.png"] forState:UIControlStateNormal];
            break;

        case 1:
            [self.tickedBtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_tick_enable.png"] forState:UIControlStateNormal];
            [self.crossedbtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_cross_disable.png"] forState:UIControlStateNormal];
            break;
            
        case -1:
            [self.tickedBtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_tick_disable.png"] forState:UIControlStateNormal];
            [self.crossedbtn setImage:[UIImage imageNamed:@"event_detail_invitee_time_cross_enable.png"] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
}

+(EventDetailInviteeConformView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailInviteeConformView" owner:self options:nil];
    EventDetailInviteeConformView * view = (EventDetailInviteeConformView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}
@end
