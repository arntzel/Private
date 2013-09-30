//
//  AddEventTimesView.m
//  Calvin
//
//  Created by xiangfang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddEventTimesView.h"
#import "AddEventTimeButton.h"
#import "AddDateEntryView.h"


@implementation AddEventTimesView {
    AddEventTimeButton * addBtn;
    NSMutableArray * _eventDates;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
    }
    return self;
}

- (void)addBtnTarget:(id)target action:(SEL)action
{
    if(addBtn == nil) {
        addBtn = [AddEventTimeButton create];
    }

    [addBtn.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(NSArray *) getEventDates
{
    return _eventDates;
}

-(void) addEventDate:(ProposeStart *) eventDate
{
    [_eventDates addObject:eventDate];

    AddDateEntryView * view = [AddDateEntryView createDateEntryView];
    view.startTimeLabel.text = [eventDate parseStartDateString];
    view.duringTimeLabel.text = [eventDate parseDuringDateString];

    //int index = self.subviews.count-1;
    [self insertSubview:view atIndex:0];
    [self layOutSubViews];
}

-(void) updateView:(NSArray *) eventDates
{
    for(UIView * view in [self subviews]) {
        [view removeFromSuperview];
    }

    _eventDates = [NSMutableArray arrayWithArray:eventDates];

    for(ProposeStart * date in eventDates) {
        AddDateEntryView * view = [AddDateEntryView createDateEntryView];
        view.startTimeLabel.text = [date parseStartDateString];
        view.duringTimeLabel.text = [date parseDuringDateString];
        [self addSubview:view];
    }

    if(addBtn == nil) {
       addBtn = [AddEventTimeButton create];
    }

    [self addSubview:addBtn];

    [self layOutSubViews];
}

- (void)layOutSubViews
{
    CGFloat offsetY = 5;

    for(UIView * subView in self.subviews) {
        CGRect frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }

    offsetY += 10;

    CGRect frame = self.frame;
    frame.size.height = offsetY;
    self.frame = frame;
}

@end
