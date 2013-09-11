//
//  EventDetailTimeLabelView.m
//  detail
//
//  Created by zyax86 on 13-8-3.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailTimeLabelView.h"

@implementation EventDetailTimeLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(EventDetailTimeLabelView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailTimeLabelView" owner:self options:nil];
    EventDetailTimeLabelView * view = (EventDetailTimeLabelView*)[nibView objectAtIndex:0];
    
    return view;
}

- (void)dealloc {
    [_title release];
    [super dealloc];
}
@end
