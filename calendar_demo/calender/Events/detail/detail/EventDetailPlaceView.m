//
//  EventDetailPlaceView.m
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailPlaceView.h"

@implementation EventDetailPlaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(EventDetailPlaceView *) creatView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailPlaceView" owner:self options:nil];
    EventDetailPlaceView * view = (EventDetailPlaceView*)[nibView objectAtIndex:0];
    
    return view;
}

@end
