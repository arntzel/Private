//
//  EventDetailPlaceView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPlaceView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailPlaceView

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
    [self.contentView.layer setShadowRadius:1.0f];
    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.contentView.layer setBorderWidth:1.0f];
    
    [self.mapView.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20f].CGColor];
    [self.mapView.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.mapView.layer setShadowRadius:1.0f];
    
    [self.layer setCornerRadius:5.0f];
    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
    [self.layer setShadowRadius:3.0f];
    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
}

+(EventDetailPlaceView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPlaceView" owner:self options:nil];
    EventDetailPlaceView * view = (EventDetailPlaceView*)[nibView objectAtIndex:0];
    [view updateUI];
    
    return view;
}

- (void)dealloc {
    [_contentView release];
    [_mapView release];
    [super dealloc];
}
@end
