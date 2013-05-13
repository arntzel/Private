//
//  CalendarIntegrationView.m
//  calender
//
//  Created by fang xiang on 13-5-13.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "CalendarIntegrationView.h"

@implementation CalendarIntegrationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(CalendarIntegrationView *) createCalendarIntegrationView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CalendarIntegrationView" owner:self options:nil];
    CalendarIntegrationView * view = (CalendarIntegrationView*)[nibView objectAtIndex:0];
    view.clipsToBounds = YES;
    view.frame = CGRectMake(0, 0, 320, CalendarIntegrationViewHeight);
    return view;
}
@end
