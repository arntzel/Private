
#import "CTimePicker.h"
#import "CLoopPickerView.h"
#import "CPickerView.h"
#import "CPickerCell.h"
#import "PickerViewProtocal.h"
#import "NSDateAdditions.h"
#import "KalDate.h"
#import "EventTimePickerDefine.h"



@interface CTimePicker()<CPickerViewProtocol>
{
    CLoopPickerView *dateTypePicker;
    CLoopPickerView *datePicker;
    CLoopPickerView *hourPicker;
    CLoopPickerView *minPicker;
    CPickerView *ampmPicker;
}
@end

@implementation CTimePicker
@synthesize dateTypeArray;
@synthesize ampmArray;
@synthesize delegate;
@synthesize monthNameArray;
@synthesize markDay;

@synthesize currentHour;
@synthesize currentMin;
@synthesize currentAMPM;
@synthesize currentType;

- (void)dealloc
{
    dateTypePicker.delegate = nil;
    datePicker.delegate = nil;
    hourPicker.delegate = nil;
    minPicker.delegate = nil;
    ampmPicker.delegate = nil;
}

- (id)initWithMarkDay:(NSDate *)day Type:(NSString *)type
{
    return [self initWithFrame:CGRectMake(0, 0, 320, CellHeight * 5) MarkDay:day Type:type];
}

- (id)initWithFrame:(CGRect)frame MarkDay:(NSDate *)day Type:(NSString *)type
{
    if (self = [super initWithFrame:frame])
    {
        [self initDate:day Type:type];
        [self definePickerWidth];
        [self initPicker:frame];
        [self setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f]];
    }
    return self;
}

+ (NSArray *)dateTypeArray
{
    return @[DATE_TYPE_ALL_DAY,
             DATE_TYPE_ANY_TIME_BEFORE,
             DATE_TYPE_EXACTLY_AT,
             DATE_TYPE_ANY_TIME_AFTER,
             DATE_TYPE_WITHIN_ANHOUR];
}

+ (NSArray *)monthNameArray
{
    return [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"April",@"May",@"Jun",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
}

+ (NSArray *)weekDayArray
{
    return [NSArray arrayWithObjects:@"Sun",@"Mon",@"Tues",@"Wed",@"Thur",@"Fri",@"Sat",nil];
}

+ (NSArray *)ampmArray
{
    return @[@"AM", @"PM"];
}


- (void)initDate:(NSDate *)day Type:(NSString *)type
{
    self.dateTypeArray = [CTimePicker dateTypeArray];
    self.monthNameArray = [CTimePicker monthNameArray];
    self.weekDayArray = [CTimePicker weekDayArray];
    self.ampmArray = [CTimePicker ampmArray];
    
    self.currentType = [self.dateTypeArray indexOfObject:type];
    self.markDay = day;
    self.dayOffset = 0;
    [self updateHourAndMin:self.markDay];
}

- (void)updateHourAndMin:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    [parts setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.currentHour = parts.hour % 12;
    self.currentAMPM = parts.hour / 12;
    self.currentMin = parts.minute;
}

- (void)definePickerWidth
{
    WIDTH_TYPE_PICKER = 110;
    WIDTH_DATE_PICKER = 90;
    WIDTH_HOUR_PICKER = 40;
    WIDTH_MIN_PICKER = 40;
    WIDTH_AMPM_PICKER = 40;
}

- (void)initPicker:(CGRect)frame
{
    dateTypePicker = [[CLoopPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_TYPE_PICKER, frame.size.height)];
    datePicker = [[CLoopPickerView alloc] initWithFrame:CGRectMake(WIDTH_TYPE_PICKER, 0, WIDTH_DATE_PICKER, frame.size.height)];
    
    hourPicker = [[CLoopPickerView alloc] initWithFrame:CGRectMake(WIDTH_TYPE_PICKER + WIDTH_DATE_PICKER, 0,
                                                                  WIDTH_HOUR_PICKER, frame.size.height)];
    minPicker = [[CLoopPickerView alloc] initWithFrame:CGRectMake(WIDTH_TYPE_PICKER + WIDTH_DATE_PICKER + WIDTH_HOUR_PICKER, 0,
                                                                 WIDTH_MIN_PICKER, frame.size.height)];
    ampmPicker = [[CPickerView alloc] initWithFrame:CGRectMake(WIDTH_TYPE_PICKER + WIDTH_DATE_PICKER + WIDTH_HOUR_PICKER + WIDTH_MIN_PICKER, 0,
                                                              WIDTH_AMPM_PICKER, frame.size.height)];
    [self addSubview:dateTypePicker];
    [self addSubview:datePicker];
    [self addSubview:hourPicker];
    [self addSubview:minPicker];
    [self addSubview:ampmPicker];
    dateTypePicker.delegate = self;
    datePicker.delegate = self;
    hourPicker.delegate = self;
    minPicker.delegate = self;
    ampmPicker.delegate = self;

    [dateTypePicker setTextAlignment:NSTextAlignmentRight];
    [datePicker setTextAlignment:NSTextAlignmentRight];
    [hourPicker setTextAlignment:NSTextAlignmentRight];
    [minPicker setTextAlignment:NSTextAlignmentRight];
    
    [dateTypePicker reloadData];
    [datePicker reloadData];
    [hourPicker reloadData];
    [minPicker reloadData];
    [ampmPicker reloadData];
    
    [ampmPicker setTextAlignment:NSTextAlignmentCenter];
    
    [dateTypePicker scrollToIndex:self.currentType WithAnimation:NO];
    [datePicker scrollToIndex:MAX_REPETA_DATA_NUMBER / 2 + 1 WithAnimation:NO];
    [hourPicker scrollToIndex:self.currentHour WithAnimation:NO];
    [minPicker scrollToIndex:self.currentMin / MIN_GAP_IN_HOUR WithAnimation:NO];
    [ampmPicker scrollToIndex:self.currentAMPM WithAnimation:NO];
}

- (void)updatePickerType:(NSInteger)index
{
    self.currentType = index;
    if (index == [dateTypeArray indexOfObject:DATE_TYPE_ALL_DAY]) {
        [hourPicker setTextHidden:YES];
        [minPicker setTextHidden:YES];
        [ampmPicker setTextHidden:YES];
    }
    else
    {
        [hourPicker setTextHidden:NO];
        [minPicker setTextHidden:NO];
        [ampmPicker setTextHidden:NO];
    }
    if ([self.delegate respondsToSelector:@selector(timePicker:changePickerType:)]) {
        [self.delegate timePicker:self changePickerType:[dateTypeArray objectAtIndex:index]];
    }
}

- (void)Picker:(id<CPickerViewInterface>)picker didSelectRowAtIndex:(NSInteger)index
{
    if (picker == dateTypePicker)
    {
        [self updatePickerType:index];
        return;
    }
    
    if (picker == datePicker)
    {
        self.dayOffset = [self getDayOffsetFromIndex:index];
    }
    else if (picker == hourPicker)
    {
        self.currentHour = index;
    }
    else if (picker == minPicker)
    {
        self.currentMin = index * MIN_GAP_IN_HOUR;
    }
    else if (picker == ampmPicker)
    {
        self.currentAMPM = index;
    }
    if ([self.delegate respondsToSelector:@selector(timeDidChanged:)])
    {
        [self.delegate timeDidChanged:self];
    }
    
}

- (NSInteger)numberOfRowsInPicker:(id<CPickerViewInterface>)picker
{
    if (picker == dateTypePicker) {
        return 5;
    }
    else if (picker == datePicker)
    {
        return MAX_REPETA_DATA_NUMBER;
    }
    else if (picker == hourPicker)
    {
        return 12;
    }
    else if (picker == minPicker)
    {
        return 12;
    }
    else if (picker == ampmPicker)
    {
        return 2;
    }
    else
    {
        return 0;
    }
}

- (NSString *)stringOfRowsInPicker:(id<CPickerViewInterface>)picker AtIndex:(NSInteger)index
{
    if (picker == dateTypePicker) {
        return [dateTypeArray objectAtIndex:index];
    }
    else if (picker == datePicker)
    {
        return [self getWeekdayStr:index];
    }
    else if (picker == hourPicker)
    {
        NSString *valueString = [NSString stringWithFormat:@"%02d",index];
        return valueString;
    }
    else if (picker == minPicker)
    {
        NSString *valueString = [NSString stringWithFormat:@"%02d",index* MIN_GAP_IN_HOUR];
        return valueString;
    }
    else if (picker == ampmPicker)
    {
        return [ampmArray objectAtIndex:index];
    }
    else
    {
        return @"";
    }
}

- (NSDate *)getDateAtIndex:(NSInteger)index
{
    NSInteger offset = [self getDayOffsetFromIndex:index];
    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:offset];
    return date;
}

- (NSString *)getWeekdayStr:(NSInteger)index
{
    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:[self getDayOffsetFromIndex:index]];
    KalDate *kalDate = [KalDate dateFromNSDate:date];
    NSInteger month = [kalDate month] - 1;
    NSInteger day = [kalDate day];
    NSInteger weekDay = [date cc_weekday] - 1;
    NSString *dateStr = @"";
    dateStr = [dateStr stringByAppendingString:[self.weekDayArray objectAtIndex:weekDay]];
    dateStr = [dateStr stringByAppendingString:@" "];
    dateStr = [dateStr stringByAppendingString:[self.monthNameArray objectAtIndex:month]];
    dateStr = [dateStr stringByAppendingString:@" "];
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", day]];
    
    return dateStr;
}

- (NSDate *)getCurrentDate
{
    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:self.dayOffset];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    [parts setHour:self.currentHour + self.currentAMPM * 12];
    [parts setMinute:self.currentMin];
    NSDate *startDate = [gregorian dateFromComponents:parts];
    
    return startDate;
}

+ (NSString *)getCurrentDateDescriptionFromeDate:(NSDate *)date type:(NSString *)type
{
    KalDate *kalDate = [KalDate dateFromNSDate:date];
    NSInteger year = [kalDate year];
    NSInteger month = [kalDate month] - 1;
    NSInteger day = [kalDate day];
    
    NSString *dateStr = @"";
    dateStr = [dateStr stringByAppendingString:[[CTimePicker monthNameArray] objectAtIndex:month]];
    dateStr = [dateStr stringByAppendingString:@" "];
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", day]];
    dateStr = [dateStr stringByAppendingString:@","];
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", year]];
    
    NSString *timeStr = @"";
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", parts.hour % 12]];
    timeStr = [timeStr stringByAppendingString:@":"];
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", parts.minute]];
    timeStr = [timeStr stringByAppendingString:[self.ampmArray objectAtIndex:parts.hour / 12]];

    if ([type isEqualToString:DATE_TYPE_ALL_DAY]) {
        return [NSString stringWithFormat:@"%@ %@", type, dateStr];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@ %@", dateStr, type, timeStr];
    }
}

- (NSString *)getCurrentDateDescription
{
    NSDate *date = [self getCurrentDate];
    NSString *dateTypeStr = [self.dateTypeArray objectAtIndex:self.currentType];
    
    return [CTimePicker getCurrentDateDescriptionFromeDate:date type:dateTypeStr];
//    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:self.dayOffset];
//    KalDate *kalDate = [KalDate dateFromNSDate:date];
//    NSInteger year = [kalDate year];
//    NSInteger month = [kalDate month] - 1;
//    NSInteger day = [kalDate day];
//    
//    NSString *dateStr = @"";
//    dateStr = [dateStr stringByAppendingString:[self.monthNameArray objectAtIndex:month]];
//    dateStr = [dateStr stringByAppendingString:@" "];
//    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", day]];
//    dateStr = [dateStr stringByAppendingString:@","];
//    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", year]];
//    
//    NSString *timeStr = @"";
//    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", self.currentHour]];
//    timeStr = [timeStr stringByAppendingString:@":"];
//    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", self.currentMin]];
//    timeStr = [timeStr stringByAppendingString:[self.ampmArray objectAtIndex:self.currentAMPM]];
//    
//    NSString *dateTypeStr = [self.dateTypeArray objectAtIndex:self.currentType];
//    if ([dateTypeStr isEqualToString:DATE_TYPE_ALL_DAY]) {
//        return [NSString stringWithFormat:@"%@ %@", dateTypeStr, dateStr];
//    }
//    else
//    {
//        return [NSString stringWithFormat:@"%@ %@ %@", dateStr, dateTypeStr, timeStr];
//    }
}


- (NSInteger)getDayOffsetFromIndex:(NSInteger)index
{
    NSInteger offset = index - (MAX_REPETA_DATA_NUMBER / 2 + 1);
    return offset;
}



@end
