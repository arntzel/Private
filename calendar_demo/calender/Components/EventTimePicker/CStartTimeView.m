#import "CStartTimeView.h"
#import "CStartTimeTitle.h"
#import "CTimePicker.h"


@interface CStartTimeView()<StartTimeTitleDelegate,TimePickerDelegate>

@property(nonatomic, strong) CStartTimeTitle *startTimeTitle;
@property(nonatomic, strong) CTimePicker *startTimePicker;

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSString *startType;

@end

@implementation CStartTimeView
@synthesize delegate;

- (void)setStartTime:(NSDate *)startTime StartType:(NSString *)startType
{
    self.startDate = startTime;
    self.startType = startType;
    [self.startTimeTitle setTime:[CTimePicker getCurrentDateDescriptionFromeDate:self.startDate type:self.startType]];
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self initStartTitle];
    }
    return self;
}

- (void)dealloc
{
    self.startTimePicker.delegate = nil;
}

- (void)initStartTitle
{
    if (self.startTimeTitle == nil) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CStartTimeTitle" owner:self options:nil];
        self.startTimeTitle = (CStartTimeTitle*)[nibView objectAtIndex:0];
        [self addSubview:self.startTimeTitle];
        self.frame = self.startTimeTitle.frame;
        self.startTimeTitle.delegate = self;
    }
}

- (void)initStartPicker
{
    if (self.startTimePicker == nil) {
        self.startTimePicker = [[CTimePicker alloc] initWithMarkDay:self.startDate Type:self.startType];
        CGRect frame = self.startTimePicker.frame;
        frame.origin.y = self.startTimeTitle.frame.size.height + VIEWGAP;
        [self.startTimePicker setFrame:frame];
        [self insertSubview:self.startTimePicker belowSubview:self.startTimeTitle];
        [self.startTimePicker setHidden:YES];
        self.startTimePicker.delegate = self;
    }
}

- (void)showStartPicker:(BOOL)animation
{
    [self initStartPicker];
    [self.startTimePicker setHidden:NO];
    
    [self setUserInteractionEnabled:NO];
    [UIView animateWithDuration:ANIMATION_DURING animations:^{
        CGRect frame = self.frame;
        frame.size.height = self.startTimePicker.frame.origin.y + self.startTimePicker.frame.size.height;
        self.frame = frame;
        if ([self.delegate respondsToSelector:@selector(startTimeViewIsShowing)]) {
            [self.delegate startTimeViewIsShowing];
        }
    } completion:^(BOOL finished) {
        [self setUserInteractionEnabled:YES];
    }];
}

- (void)HiddenStartPicker:(BOOL)animation
{
    if (animation) {
        [self.startTimePicker setHidden:NO];
        [self setUserInteractionEnabled:NO];
        [UIView animateWithDuration:ANIMATION_DURING animations:^{
            self.startTimePicker.transform = CGAffineTransformMakeTranslation(0, -self.frame.size.height);
            self.frame = self.startTimeTitle.frame;
            if ([self.delegate respondsToSelector:@selector(startTimeViewIsHiddening)]) {
                [self.delegate startTimeViewIsHiddening];
            }
        } completion:^(BOOL finished) {
            self.startTimePicker.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.startTimePicker setHidden:YES];
            [self setUserInteractionEnabled:YES];
        }];
    }
    else
    {
        self.frame = self.startTimeTitle.frame;
        [self.startTimePicker setHidden:YES];
    }
}

- (void)didTapdView:(UIView *)view
{
    if ([self.delegate respondsToSelector:@selector(didTapdView:)]) {
        [self.delegate didTapdView:self];
    }
}

- (BOOL)isTimePickerHidden
{
    return self.startTimePicker.hidden;
}

- (void)timePicker:(CTimePicker *)picker changePickerType:(NSString *)datePickerType
{
    self.startType = datePickerType;
    if ([datePickerType isEqualToString:DATE_TYPE_ALL_DAY]) {
        if ([self.delegate respondsToSelector:@selector(showEndTimePicker:)]) {
            [self.delegate showEndTimePicker:NO];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(showEndTimePicker:)]) {
            [self.delegate showEndTimePicker:YES];
        }
    }
    
    if ([datePickerType isEqualToString:DATE_TYPE_EXACTLY_AT]) {
        if ([self.delegate respondsToSelector:@selector(setEndEventTimePicker:)]) {
            [self.delegate setEndEventTimePicker:EndTimeType_End];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(setEndEventTimePicker:)]) {
            [self.delegate setEndEventTimePicker:EndTimeType_During];
        }
    }
    [self.startTimeTitle setTime:[CTimePicker getCurrentDateDescriptionFromeDate:self.startDate type:self.startType]];
    if ([self.delegate respondsToSelector:@selector(startTimeView:changePickerType:)]) {
        [self.delegate startTimeView:self changePickerType:datePickerType];
    }
}

- (void)timeDidChanged:(CTimePicker *)picker
{
    self.startDate = [picker getCurrentDate];
    [self.startTimeTitle setTime:[CTimePicker getCurrentDateDescriptionFromeDate:self.startDate type:self.startType]];
    if ([self.delegate respondsToSelector:@selector(startTimeView:timeDidChanged:)]) {
        [self.delegate startTimeView:self timeDidChanged:self.startDate];
    }
}

@end
