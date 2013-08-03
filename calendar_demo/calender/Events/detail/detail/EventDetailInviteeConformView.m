//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeConformView.h"

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
    [super dealloc];
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
    
    return view;
}
@end
