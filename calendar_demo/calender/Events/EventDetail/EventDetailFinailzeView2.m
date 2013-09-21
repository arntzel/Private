//
//  EventDetailFinailzeView2.m
//  Calvin
//
//  Created by xiangfang on 13-9-21.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventDetailFinailzeView2.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailFinailzeView2

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

+(EventDetailFinailzeView2 *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView2" owner:self options:nil];
    EventDetailFinailzeView2 * view = (EventDetailFinailzeView2*)[nibView objectAtIndex:0];
    [view updateUI];
    return view;
}

@end
