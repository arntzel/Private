//
//  EventDetailFinailzeView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailFinailzeView.h"

@implementation EventDetailFinailzeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_finailzeView release];
    [_removeView release];
    [super dealloc];
}

+(EventDetailFinailzeView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView" owner:self options:nil];
    EventDetailFinailzeView * view = (EventDetailFinailzeView*)[nibView objectAtIndex:0];
    
    return view;
}
@end
