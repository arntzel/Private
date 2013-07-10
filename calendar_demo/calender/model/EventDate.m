
#import "EventDate.h"

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
