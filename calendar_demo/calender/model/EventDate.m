
#import "EventDate.h"


@interface EventDate()<NSCopying>

@end

@implementation EventDate

- (id)init
{
    self = [super init];
    if (self) {
        self.is_all_day = NO;
        self.start = [NSDate date];
        self.end = [NSDate date];
        self.duration_days = 0;
        self.duration_minutes = 0;
        self.duration_hours = 0;
        self.start_type = START_TYPEEXACTLYAT;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    EventDate *newDate = [[EventDate alloc] init];
    newDate.start = [self.start copy];
    newDate.end = [self.end copy];
    newDate.is_all_day = self.is_all_day;
    newDate.start_type = [self.start_type copy];
    
    newDate.duration_days = self.duration_days;
    newDate.duration_minutes = self.duration_minutes;
    newDate.duration_hours = self.duration_hours;
    
    return newDate;
}

- (void)convertMinToQuarterMode
{

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self.start];
    parts.minute += 14;

    NSInteger min = [parts minute];
    parts.minute = (min / 15) * 15;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:parts];
    self.start = date;
}


- (NSString *)parseStartTimeString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];
    NSString *dateStr = [format stringFromDate:self.start];
    NSString *preStr = @"";
    
    if ([self.start_type isEqualToString:START_TYPEEXACTLYAT]) {
        preStr = @"exactly at ";
    }
    else if ([self.start_type isEqualToString:START_TYPEWITHIN]) {
        preStr = @"within an hour of ";
    }
    else if ([self.start_type isEqualToString:START_TYPEAFTER]) {
        preStr = @"anytime after ";
    }
    
    return [preStr stringByAppendingString:dateStr];
}

- (NSString *)parseStartDateString
{
    NSArray *monthNameArray = [NSArray arrayWithObjects:
                               @"jan",
                               @"feb",
                               @"march",
                               @"april",
                               
                               @"may",
                               @"june",
                               @"july",
                               @"aug",
                               
                               @"sep",
                               @"oct",
                               @"nov",
                               @"dec",
                               nil
                               ];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.start];
    
    NSString *monthName = [monthNameArray objectAtIndex:parts.month - 1];
    NSString *preFix = [NSString stringWithFormat:@"%@ %dth",monthName,parts.day];
    
    return [NSString stringWithFormat:@"%@,%@",preFix,[self parseStartTimeString]];
}

- (NSString *)parseDuringDateString
{

    if (self.is_all_day) {
        return @"all day";
    }
    
    NSString *duringDateString = [NSString stringWithFormat:@"%d hours %d minutes", self.duration_hours, self.duration_minutes];
    
    return duringDateString;
}

@end
