//
//  EventDetailHeader.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailHeader.h"

@implementation EventDetailHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTicked
{
    [self.crossView setHidden:YES];
    [self.tickView setHidden:NO];
}


- (void)setCrossed
{
    [self.crossView setHidden:NO];
    [self.tickView setHidden:YES];
}

- (void)dealloc {
    [_headerView release];
    [_crossView release];
    [_tickView release];
    [super dealloc];
}
@end
