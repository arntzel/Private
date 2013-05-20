//
//  PlanView.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventView.h"
#import "Utils.h"

@implementation EventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) refreshView:(Event *) event
{
    self.labTitle.text = event.eventTitle;
    self.labAttendees.text = event.attenedees;
    self.labLocation.text = event.location.locationName;

    self.labTime.text = [Utils formateTime:event.startTime];

    if(event.eventType == 0) {
        self.imgStatus.image = [UIImage imageNamed:@"circle2"];
    } else {
        self.imgStatus.image = [UIImage imageNamed:@"circle"];
    }
}


+(EventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    EventView * view = (EventView*)[nibView objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    return view;
}

@end
