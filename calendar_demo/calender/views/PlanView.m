//
//  PlanView.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "PlanView.h"
#import "Plan.h"
#import "Utils.h"

@implementation PlanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) refreshView:(Plan *) plan
{
    self.labTitle.text = plan.title;
    self.labAttendees.text = plan.attenedees;
    self.labLocation.text = plan.location.locationName;

    self.labTime.text = [Utils formateTime:plan.time];

    if(plan.status == 0) {
        self.imgStatus.image = [UIImage imageNamed:@"circle2"];
    } else {
        self.imgStatus.image = [UIImage imageNamed:@"circle"];
    }
}


+(PlanView *) createPlanView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PlanView" owner:self options:nil];
    PlanView * view = (PlanView*)[nibView objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    return view;
}

@end
