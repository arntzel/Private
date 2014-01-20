#import "CEndTimeView.h"
#import "CEndTimeTitle.h"
#import "CEndTimePicker.h"
#import "CDuringTimePicker.h"
#import "EventTimePickerDefine.h"



@interface CEndTimeView()<EndTimeTitleDelegate,TimePickerDelegate,DuringTimePickerDelegate>


@property(nonatomic) NSInteger endTimeType;
@property(nonatomic, strong) CEndTimeTitle *endTimeTitle;
@property(nonatomic, strong) CEndTimePicker *endTimePicker;
@property(nonatomic, strong) CDuringTimePicker *duringTimePicker;

@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic) NSInteger duringMinites;

@end

@implementation CEndTimeView
@synthesize delegate;
@synthesize endTimeTitle;
@synthesize endTimePicker;
@synthesize duringTimePicker;
@synthesize endTimeType;

@synthesize endDate;
@synthesize duringMinites;

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setEndTime:(NSDate *)endTime During:(NSInteger )during_
{
    self.endDate = endTime;
    self.duringMinites = during_;
    [self updateTitleView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setClipsToBounds:YES];
        [self initEndTitle];
    }
    return self;
}

- (void)dealloc
{
    self.endTimePicker.delegate = nil;
}

- (void)initEndTitle
{
    if (self.endTimeTitle == nil) {
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CEndTimeTitle" owner:self options:nil];
        self.endTimeTitle = (CEndTimeTitle*)[nibView objectAtIndex:0];
        [self addSubview:self.endTimeTitle];
        self.frame = self.endTimeTitle.frame;
        self.endTimeTitle.delegate = self;
    }
}

- (void)initEndPicker
{
    if (self.endTimePicker == nil) {
        self.endTimePicker = [[CEndTimePicker alloc] initWithMarkDay:self.endDate Type:DATE_TYPE_EXACTLY_AT];
        CGRect frame = self.endTimePicker.frame;
        frame.origin.y = self.endTimeTitle.frame.size.height + VIEWGAP;
        [self.endTimePicker setFrame:frame];
        [self insertSubview:self.endTimePicker belowSubview:self.endTimeTitle];
        [self.endTimePicker setHidden:YES];
        self.endTimePicker.delegate = self;
    }
}

- (void)initDuringPicker
{
    if (self.duringTimePicker == nil) {
        self.duringTimePicker = [[CDuringTimePicker alloc] init];
        [self.duringTimePicker setDuringTime:self.duringMinites];
        CGRect frame = self.duringTimePicker.frame;
        frame.origin.y = self.endTimeTitle.frame.size.height + VIEWGAP;
        [self.duringTimePicker setFrame:frame];
        [self insertSubview:self.duringTimePicker belowSubview:self.endTimeTitle];
        [self.duringTimePicker setHidden:YES];
        self.duringTimePicker.delegate = self;
    }
}

- (void)showEndPicker:(UIView *)Picker withAnimation:(BOOL)animation
{
    [Picker setHidden:NO];
    
    [self setUserInteractionEnabled:NO];
    Picker.transform = CGAffineTransformMakeTranslation(0, -Picker.frame.size.height);
    [UIView animateWithDuration:ANIMATION_DURING animations:^{
        Picker.transform = CGAffineTransformMakeTranslation(0, 0);
        CGRect frame = self.frame;
        frame.size.height = Picker.frame.origin.y + Picker.frame.size.height;
        self.frame = frame;
        if ([self.delegate respondsToSelector:@selector(EndTimeViewIsShowing)]) {
            [self.delegate EndTimeViewIsShowing];
        }
    } completion:^(BOOL finished) {
        [self setUserInteractionEnabled:YES];
    }];
}

- (void)hiddenEndPicker:(UIView *)Picker withAnimation:(BOOL)animation
{
    [Picker setHidden:NO];
    
    if (animation) {
        [self setUserInteractionEnabled:NO];
        [UIView animateWithDuration:ANIMATION_DURING animations:^{
            CGRect frame = self.frame;
            frame.size.height = self.endTimeTitle.frame.size.height;
            self.frame = frame;
            if ([self.delegate respondsToSelector:@selector(EndTimeViewIsHiddening)]) {
                [self.delegate EndTimeViewIsHiddening];
            }
        } completion:^(BOOL finished) {
            [Picker setHidden:YES];
            [self setUserInteractionEnabled:YES];
        }];
    }
    else
    {
        CGRect frame = self.frame;
        frame.size.height = self.endTimeTitle.frame.size.height;
        self.frame = frame;
        [Picker setHidden:YES];
    }
}

- (void)showEndPicker:(BOOL)animation
{
    if (self.endTimeType == EndTimeType_End) {
        [self initEndPicker];
        [self showEndPicker:self.endTimePicker withAnimation:animation];
    }
    else if (self.endTimeType == EndTimeType_During)
    {
        [self initDuringPicker];
        [self showEndPicker:self.duringTimePicker withAnimation:animation];
    }
}

- (void)HiddenEndPicker:(BOOL)animation
{
    if (self.endTimeType == EndTimeType_End) {
        [self hiddenEndPicker:self.endTimePicker withAnimation:animation];
    }
    else if (self.endTimeType == EndTimeType_During)
    {
        [self hiddenEndPicker:self.duringTimePicker withAnimation:animation];
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
    return self.endTimePicker.hidden;
}

- (void)setMode:(NSInteger)mode
{
    self.endTimeType = mode;
    [self updateTitleView];
}

- (void)updateTitleView
{
    if (self.endTimeType == EndTimeType_End)
    {
        [self.endTimeTitle setEndTimeMode];
        [self.endTimeTitle setTime:[CEndTimePicker getCurrentDateDescriptionFromeDate:self.endDate]];
    }
    else if (self.endTimeType == EndTimeType_During)
    {
        [self.endTimeTitle setDuringTimeMode];
        [self.endTimeTitle setTime:[CDuringTimePicker getFormatTimeForMinites:self.duringMinites]];
    }
}

- (void)DuringTimePicker:(CDuringTimePicker *)picker didChooseMinites:(NSInteger)minites
{
    self.duringMinites = minites;
    [self.endTimeTitle setTime:[CDuringTimePicker getFormatTimeForMinites:self.duringMinites]];
    
    if ([self.delegate respondsToSelector:@selector(endTimeView:duringDidChanged:)]) {
        [self.delegate endTimeView:self duringDidChanged:self.duringMinites];
    }
}

- (void)timePicker:(CTimePicker *)picker changePickerType:(NSString *)datePickerType
{
    
}

- (void)timeDidChanged:(CTimePicker *)picker
{
    self.endDate = [picker getCurrentDate];
    [self.endTimeTitle setTime:[CEndTimePicker getCurrentDateDescriptionFromeDate:self.endDate]];
    
    if ([self.delegate respondsToSelector:@selector(endTimeView:timeDidChanged:)]) {
        [self.delegate endTimeView:self timeDidChanged:self.endDate];
    }
}


@end
