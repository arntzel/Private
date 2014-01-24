#import "CEventTimePicker.h"
#import "CEventTimeTitle.h"
#import "CStartTimeView.h"
#import "CEndTimeView.h"
#import "EventTimePickerDefine.h"


#define VIEW_MODE_EVENT_TITLE 1
#define VIEW_MODE_START 2
#define VIEW_MODE_END 3

@interface CEventTimePicker()<EventTimeTitleDelegate, StartTimeViewDelegate, EndTimeViewDelegate>
{
    NSInteger ViewMode;
    ProposeStart *pickerTime;
}

@property(nonatomic, strong) CEventTimeTitle *eventTimeTitle;
@property(nonatomic, strong) CStartTimeView *startTimeView;
@property(nonatomic, strong) CEndTimeView *endTimeView;

@property(nonatomic, strong) ProposeStart *pickerTime;

@end

@implementation CEventTimePicker
@synthesize eventTimeTitle;
@synthesize startTimeView;
@synthesize endTimeView;
@synthesize pickerTime;
@synthesize delegate;


- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self initEventTitle];
        self.startTimeView = [[CStartTimeView alloc] init];
        self.endTimeView = [[CEndTimeView alloc] init];
        [self addSubview:self.startTimeView];
        [self addSubview:self.endTimeView];
        [self ajustEndTimeViewFrame];
        [self.startTimeView setHidden:YES];
        [self.endTimeView setHidden:YES];
        
        self.startTimeView.delegate = self;
        self.endTimeView.delegate = self;
    }
    return self;
}

+ (NSString *)getStartTypeFromePropseType:(ProposeStart *)startTime
{
    NSString *type = @"";
    if (startTime.is_all_day == YES) {
        type = DATE_TYPE_ALL_DAY;
    }
    else if ([startTime.start_type isEqualToString:START_TYPEAFTER])
    {
        type = DATE_TYPE_ANY_TIME_AFTER;
    }
    else if ([startTime.start_type isEqualToString:START_TYPEWITHIN])
    {
        type = DATE_TYPE_WITHIN_ANHOUR;
    }
    else if ([startTime.start_type isEqualToString:START_TYPEEXACTLYAT])
    {
        type = DATE_TYPE_EXACTLY_AT;
    }
    return type;
}

- (void)setTime:(ProposeStart *)time_
{
    pickerTime = time_;
    
    NSString *type = [CEventTimePicker getStartTypeFromePropseType:pickerTime];
    
    [self.startTimeView setStartTime:pickerTime.start StartType:type];
    [self.endTimeView setEndTime:pickerTime.end During:pickerTime.duration_hours * 60 + pickerTime.duration_minutes];
    
    if ([type isEqualToString:DATE_TYPE_EXACTLY_AT]) {
        [self.endTimeView setMode:EndTimeType_End];
    }
    else
    {
        [self.endTimeView setMode:EndTimeType_During];
    }
    [self updateTitleView];
}

- (ProposeStart *)getTime
{
    return pickerTime;
}

- (void)initEventTitle
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CEventTimeTitle" owner:self options:nil];
    self.eventTimeTitle = (CEventTimeTitle*)[nibView objectAtIndex:0];
    self.eventTimeTitle.delegate = self;
    [self setFrame:self.eventTimeTitle.frame];
    [self addSubview:self.eventTimeTitle];
}

- (void)startTimeViewIsHiddening
{
    [self reLayout];
}

- (void)startTimeViewIsShowing
{
    [self reLayout];
}

- (void)EndTimeViewIsHiddening
{
    [self reLayout];
}

- (void)EndTimeViewIsShowing
{
    [self reLayout];
}

- (void)ajustEndTimeViewFrame
{
    CGRect frame = self.endTimeView.frame;
    frame.origin.y = self.startTimeView.frame.origin.y + self.startTimeView.frame.size.height + VIEWGAP;
    self.endTimeView.frame = frame;
}

- (void)reLayout
{
    [self ajustEndTimeViewFrame];
    
    if (self.endTimeView.hidden != YES) {
        CGRect frame = self.frame;
        frame.size.height = self.endTimeView.frame.origin.y + self.endTimeView.frame.size.height;
        self.frame = frame;
    }
    else
    {
        CGRect frame = self.frame;
        frame.size.height = self.startTimeView.frame.origin.y + self.startTimeView.frame.size.height;
        self.frame = frame;
    }
    if ([self.delegate respondsToSelector:@selector(EventTimePickerNeedLayout:)]) {
        [self.delegate EventTimePickerNeedLayout:self];
    }
}

-(void) didDeleteTime:(UIView *) view
{
    [self.delegate eventTimePickerDelete:self];
}

- (void)didTapdView:(UIView *)view
{
    if (view == self.eventTimeTitle)
    {
        [self getFocus];
    }
    else if(view == self.startTimeView)
    {
        if ([self.startTimeView isTimePickerHidden]) {
            [self.startTimeView showStartPicker:YES];
            [self.endTimeView HiddenEndPicker:NO];
        } else {
            [self loseFocus];
        }
    }
    else if (view == self.endTimeView)
    {
        if (![self.startTimeView isTimePickerHidden]) {
            [self.endTimeView showEndPicker:YES];
            [self.startTimeView HiddenStartPicker:YES];
        } else {
            [self loseFocus];
        }
    }
}

- (void)getFocus
{
    [self setUserInteractionEnabled:NO];
    
    [self.eventTimeTitle setHidden:NO];
    [self.startTimeView setHidden:NO];
    [self.endTimeView setHidden:NO];
    
    self.eventTimeTitle.alpha = 1.0f;
    self.startTimeView.alpha = .0f;
    self.endTimeView.alpha = .0f;
    
    [UIView animateWithDuration:ANIMATION_DURING animations:^{
        self.eventTimeTitle.alpha = 0.0f;
        self.startTimeView.alpha = 1.0f;
        self.endTimeView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.eventTimeTitle setHidden:YES];
        [self setUserInteractionEnabled:YES];
    }];
    
    [self.startTimeView showStartPicker:YES];
}

- (void)loseFocus
{
    if (self.eventTimeTitle.hidden == YES) {
        [self.eventTimeTitle setHidden:NO];
        [self.eventTimeTitle setAlpha:0.0f];
        
        [self.startTimeView setHidden:NO];
        [self.endTimeView setHidden:NO];
        
        [self setUserInteractionEnabled:NO];

        [UIView animateWithDuration:ANIMATION_DURING animations:^{
            self.startTimeView.alpha = .0f;
            self.endTimeView.alpha = .0f;
            self.eventTimeTitle.alpha = 1.0f;
            CGRect frame = self.frame;
            frame.size.height = self.eventTimeTitle.frame.size.height;
            self.frame = frame;
            
            if ([self.delegate respondsToSelector:@selector(EventTimePickerNeedLayout:)]) {
                [self.delegate EventTimePickerNeedLayout:self];
            }
        } completion:^(BOOL finished) {
            [self.startTimeView HiddenStartPicker:NO];
            [self.endTimeView HiddenEndPicker:NO];
            
            self.startTimeView.alpha = 1.0f;
            self.endTimeView.alpha = 1.0f;
            [self.startTimeView setHidden:YES];
            [self.endTimeView setHidden:YES];
            
            [self setUserInteractionEnabled:YES];
        }];
    }
}

- (void)showEndTimePicker:(BOOL)show
{
    [self.endTimeView setHidden:!show];
    [self reLayout];
}

- (void)setEndEventTimePicker:(NSInteger)endTimeType
{
    [self.endTimeView setMode:endTimeType];
}

- (void)startTimeView:(CStartTimeView *)picker changePickerType:(NSString *)datePickerType
{
    if ([datePickerType isEqualToString:DATE_TYPE_ALL_DAY]) {
        pickerTime.is_all_day = YES;
    }
    if ([datePickerType isEqualToString:DATE_TYPE_EXACTLY_AT]) {
        pickerTime.start_type = START_TYPEEXACTLYAT;
        pickerTime.is_all_day = NO;
    }
    else if ([datePickerType isEqualToString:DATE_TYPE_ANY_TIME_AFTER] || [datePickerType isEqualToString:DATE_TYPE_ANY_TIME_BEFORE]) {
        pickerTime.start_type = START_TYPEAFTER;
        pickerTime.is_all_day = NO;
    }
    else if ([datePickerType isEqualToString:DATE_TYPE_WITHIN_ANHOUR]) {
        pickerTime.start_type = START_TYPEWITHIN;
        pickerTime.is_all_day = NO;
    }
    [self updateTitleView];
}

- (void)startTimeView:(CStartTimeView *)picker timeDidChanged:(NSDate *)changedTime
{
    pickerTime.start = changedTime;
    [self updateTitleView];
}

- (void)endTimeView:(CEndTimeView *)picker duringDidChanged:(NSInteger)duringMinite_
{
    pickerTime.duration_days = 0;
    pickerTime.duration_hours = duringMinite_ / 60;
    pickerTime.duration_minutes = duringMinite_ % 60;
    [self updateTitleView];
}


- (void)endTimeView:(CEndTimeView *)picker timeDidChanged:(NSDate *)endDate_
{
    pickerTime.end = endDate_;
    [self updateTitleView];
}

- (void)updateTitleView
{
    [eventTimeTitle setTime:self.pickerTime];
}

@end
