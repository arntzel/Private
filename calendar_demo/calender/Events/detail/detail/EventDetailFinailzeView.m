//
//  EventDetailFinailzeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailFinailzeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailFinailzeView

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

- (void)dealloc {
    [_finailzeView release];
    [_removeView release];
    [_contentView release];
    [super dealloc];
}

+(EventDetailFinailzeView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView" owner:self options:nil];
    EventDetailFinailzeView * view = (EventDetailFinailzeView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}
@end
