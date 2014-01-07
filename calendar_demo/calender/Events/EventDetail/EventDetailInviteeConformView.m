//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeConformView.h"
#import "EventDetailRoundDateView.h"
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
        self.eventTimeConflictLabel.text = [NSString stringWithFormat:@"%d Conflicts", count];
        [self.eventTimeConflictLabel setHidden:NO];
    } else {
        [self.eventTimeConflictLabel setHidden:YES];
    }
//    if (count > 0) {
//        self.eventTimeConflictLabel.text = [NSString stringWithFormat:@"%d Conflicts", count];
//        [self.eventTimeConflictLabel setHidden:NO];
//        CGRect frame = self.eventTimeLabel.frame;
//        frame.origin.y = 20;
//        [self.eventTimeLabel setFrame:frame];
//        
//        frame = self.timeLabelButton.frame;
//        frame.origin.y = 20;
//        [self.timeLabelButton setFrame:frame];
////        [self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, 20)];
//    }
//    else
//    {
//        [self.eventTimeLabel setCenter:CGPointMake(self.eventTimeLabel.center.x, self.frame.size.height / 2)];
//        [self.eventTimeConflictLabel setHidden:YES];
//    }
    
}



//- (void)dealloc {
//    [_tickedBtn release];
//    [_crossedbtn release];
//    [_cfmedLabel release];
//    [_eventTypeLabel release];
//    [_declinesLabel release];
//    [_voteStateBtn release];
//    [_contentView release];
//    self.voteStateBtn = nil;
//    
//    self.eventTimeLabel = nil;
//    self.eventTypeLabel = nil;
//    self.cfmedLabel = nil;
//    self.declinesLabel = nil;
//    self.eventTimeConflictLabel = nil;
//    [super dealloc];
//}

- (void)updateUI
{
    CALayer *bottomBorder = [CALayer layer];
    float height=self.frame.size.height-1.0f;
    float width=self.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor;
    [self.layer addSublayer:bottomBorder];
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

- (void)showFinalizedFlag
{
    [self.finalizedTick setHidden:NO];
    [self.finalizedLabel setHidden:NO];
    [self.viewVoteArrow setHidden:YES];
    
    CGRect frame = self.cfmImg.frame;
    frame.origin.x -= 13;
    self.cfmImg.frame = frame;
    
    frame = self.cfmedLabel.frame;
    frame.origin.x -=13;
    self.cfmedLabel.frame = frame;
    
    frame = self.declinesLabel.frame;
    frame.origin.x -=13;
    self.declinesLabel.frame = frame;
    
    frame = self.dclImg.frame;
    frame.origin.x -=13;
    self.dclImg.frame = frame;
//    CGRect timeFrame = self.eventTimeLabel.frame;
//    timeFrame.origin.y = 8;
//    [self.eventTimeLabel setFrame:timeFrame];
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
            [self.tickedBtn setBackgroundImage:[UIImage imageNamed:@"gray1_error.png"] forState:UIControlStateNormal];
            [self.crossedbtn setBackgroundImage:[UIImage imageNamed:@"gray2_error.png"] forState:UIControlStateNormal];
            break;

        case 1:
            [self.tickedBtn setBackgroundImage:[UIImage imageNamed:@"green_error.png"] forState:UIControlStateNormal];
            [self.crossedbtn setBackgroundImage:[UIImage imageNamed:@"gray2_error.png"] forState:UIControlStateNormal];
            break;
            
        case -1:
            [self.tickedBtn setBackgroundImage:[UIImage imageNamed:@"gray1_error.png"] forState:UIControlStateNormal];
            [self.crossedbtn setBackgroundImage:[UIImage imageNamed:@"red_error.png"] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
}

+(EventDetailInviteeConformView *) creatView
{
    return [self creatViewWithStartDate:nil];
}

+(EventDetailInviteeConformView *) creatViewWithStartDate:(NSDate *)date
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailInviteeConformView" owner:self options:nil];
    EventDetailInviteeConformView * view = (EventDetailInviteeConformView*)[nibView objectAtIndex:0];
    
    //[view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:243.0/255.0 blue:236.0/255.0 alpha:0.7]];
    [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2]];
    [view updateUI];
    
    EventDetailRoundDateView *dateView = [[EventDetailRoundDateView alloc]initWithFrame:CGRectMake(0.0, 8.0, 50.0, 50.0) withDate:date];
    [view addSubview:dateView];
    
    
    return view;
}
@end
