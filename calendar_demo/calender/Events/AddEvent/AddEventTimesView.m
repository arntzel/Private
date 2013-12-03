

#import "AddEventTimesView.h"
#import "AddEventTimeButton.h"
#import "AddDateEntryView.h"

@interface AddEventTimesView()<AddDateEntryViewDelegate>

@end


@implementation AddEventTimesView {
    AddEventTimeButton * addBtn;
    NSMutableArray * _eventDates;
    AddDateEntryView *willUpdateTimeView;
}
@synthesize delegate;

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
    view.delegate = self;
    view.startTimeLabel.text = [eventDate parseStartDateString];
    view.duringTimeLabel.text = [eventDate parseDuringDateString];
    view.eventData = eventDate;

    //int index = self.subviews.count-1;
    [self insertSubview:view atIndex:0];
    
    if(_eventDates.count >=3) {
        addBtn.hidden = YES;
    }
    
    [UIView animateWithDuration:0.6f animations:^{
        [self layOutSubViews];
        [self.delegate layOutSubViews];
    }];
}

-(void) updateView:(NSArray *) eventDates
{
    for(UIView * view in [self subviews]) {
        [view removeFromSuperview];
    }

    _eventDates = [NSMutableArray arrayWithArray:eventDates];

    for(ProposeStart * date in eventDates) {
        AddDateEntryView * view = [AddDateEntryView createDateEntryView];
        view.eventData = date;
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
        
        if(subView.hidden == YES) continue;
        
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

- (void)removeEventDataView:(AddDateEntryView *)dateEntry
{
    [_eventDates removeObject:dateEntry.eventData];
    [dateEntry removeFromSuperview];
    
    addBtn.hidden = NO;
    
    [UIView animateWithDuration:0.6f animations:^{
        [self layOutSubViews];
        [self.delegate layOutSubViews];
    }];
}

- (void)updateEventData:(ProposeStart *)eventData
{
    willUpdateTimeView.startTimeLabel.text = [eventData parseStartDateString];
    willUpdateTimeView.duringTimeLabel.text = [eventData parseDuringDateString];
    ProposeStart *date = willUpdateTimeView.eventData;
    date.start = eventData.start;
    date.start_type = eventData.start_type;
    date.duration_days = eventData.duration_days;
    date.duration_hours = eventData.duration_hours;
    date.duration_minutes = eventData.duration_minutes;
    date.is_all_day = eventData.is_all_day;
}

- (void)updateEventDataView:(AddDateEntryView *)dateEntry
{
    willUpdateTimeView = dateEntry;
    ProposeStart *eventData = dateEntry.eventData;
    
    if ([self.delegate respondsToSelector:@selector(updateDate:)]) {
        [self.delegate updateDate:eventData];
    }
}

@end
