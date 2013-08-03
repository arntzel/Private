//
//  EventDetailInviteeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailInviteeView.h"

@implementation EventDetailInviteeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateUI
{
    
}

+(EventDetailInviteeView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailInviteeView" owner:self options:nil];
    EventDetailInviteeView * view = (EventDetailInviteeView*)[nibView objectAtIndex:0];
    
    return view;
}

- (void)dealloc {
    [_inviteeLabel release];
    [super dealloc];
}
@end
