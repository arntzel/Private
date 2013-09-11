//
//  EventDetailHeader.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailHeader.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailHeader

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)updateUI
{
    [self.headerView setClipsToBounds:YES];
    [self.headerView.layer setCornerRadius:self.headerView.frame.size.width / 2];
    
    [self.headerView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.headerView.layer setShadowRadius:3.0f];
    [self.headerView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.headerView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.headerView.layer setBorderWidth:1.0f];

}

-(void) setHeaderUrl:(NSString *) url
{
    
}

- (void)setHeader:(UIImage *)header
{
    self.headerView.image = header;
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

- (void)setTickAndCrossHidden
{
    [self.crossView setHidden:YES];
    [self.tickView setHidden:YES];
}

- (void)dealloc {
    [_headerView release];
    [_crossView release];
    [_tickView release];
    [super dealloc];
}

+(EventDetailHeader *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailHeader" owner:self options:nil];
    EventDetailHeader * view = (EventDetailHeader*)[nibView objectAtIndex:0];
    
    return view;
}
@end
