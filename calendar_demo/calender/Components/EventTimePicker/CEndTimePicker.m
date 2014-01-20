
#import "CEndTimePicker.h"
#import "CLoopPickerView.h"
#import "CPickerView.h"
#import "CPickerCell.h"
#import "PickerViewProtocal.h"
#import "NSDateAdditions.h"
#import "KalDate.h"
#import "EventTimePickerDefine.h"





@implementation CEndTimePicker
    
- (void)definePickerWidth
{
    WIDTH_DATE_PICKER = 140;
    WIDTH_HOUR_PICKER = 50;
    WIDTH_MIN_PICKER = 50;
    WIDTH_AMPM_PICKER = 80;
}

+ (NSString *)getCurrentDateDescriptionFromeDate:(NSDate *)date
{
    KalDate *kalDate = [KalDate dateFromNSDate:date];
    NSInteger month = [kalDate month] - 1;
    NSInteger day = [kalDate day];

    NSString *dateStr = @"";
    dateStr = [dateStr stringByAppendingString:[[CTimePicker monthNameArray] objectAtIndex:month]];
    dateStr = [dateStr stringByAppendingString:@" "];
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", day]];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
    
    NSString *timeStr = @"";
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", parts.hour % 12]];
    timeStr = [timeStr stringByAppendingString:@":"];
    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", parts.minute]];
    timeStr = [timeStr stringByAppendingString:[[CTimePicker ampmArray] objectAtIndex:parts.hour / 12]];


    return [NSString stringWithFormat:@"%@ %@", dateStr, timeStr];
}

- (NSString *)getCurrentDateDescription
{
    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:self.dayOffset];
    return [CEndTimePicker getCurrentDateDescriptionFromeDate:date];
    
//    NSDate *date = [self.markDay cc_dateByMovingToTheFollowingDayCout:self.dayOffset];
//    KalDate *kalDate = [KalDate dateFromNSDate:date];
//    NSInteger month = [kalDate month] - 1;
//    NSInteger day = [kalDate day];
//    
//    NSString *dateStr = @"";
//    dateStr = [dateStr stringByAppendingString:[self.monthNameArray objectAtIndex:month]];
//    dateStr = [dateStr stringByAppendingString:@" "];
//    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@"%d", day]];
//    
//    NSString *timeStr = @"";
//    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d", self.currentHour]];
//    timeStr = [timeStr stringByAppendingString:@":"];
//    timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%02d", self.currentMin]];
//    timeStr = [timeStr stringByAppendingString:[self.ampmArray objectAtIndex:self.currentAMPM]];
//    
//
//    return [NSString stringWithFormat:@"%@ %@", dateStr, timeStr];
}

@end
