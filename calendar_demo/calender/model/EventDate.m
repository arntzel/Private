
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


- (NSString *)parseStartDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [format stringFromDate:self.start];
    NSString *preStr = @"";
    
    if ([self.start_type isEqualToString:START_TYPEEXACTLYAT]) {
        preStr = @"start exactly at ";
    }
    else if ([self.start_type isEqualToString:START_TYPEWITHIN]) {
        preStr = @"start within an hour of ";
    }
    else if ([self.start_type isEqualToString:START_TYPEAFTER]) {
        preStr = @"anytime after ";
    }
    
    return [preStr stringByAppendingString:dateStr];
}

- (NSString *)parseDuringDateString
{

    if (self.is_all_day) {
        return @"All Day";
    }
    
    NSString *duringDateString = [NSString stringWithFormat:@"%d hours %d minutes", self.duration_hours, self.duration_minutes];
    
    return duringDateString;
}

@end
