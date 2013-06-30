#import "KalLogicUtils.h"

@implementation KalLogicUtils

//week
+ (NSArray *)visibleWeekDaysForDay:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    NSUInteger currentWeekDay = [date cc_weekday];
    
    NSLog(@"currentWeekDay :%d",currentWeekDay);
    for (NSUInteger index = 1; index < currentWeekDay; index++)
    {
        NSDate *d = [date cc_dateByMovingToThePreviousDayCout:currentWeekDay - index];
        [days addObject:[KalDate dateFromNSDate:d]];
    }
    for (NSUInteger index = 7 ; index >= currentWeekDay; index--)
    {
        NSDate *d = [date cc_dateByMovingToTheFollowingDayCout:7 - index];
        [days addObject:[KalDate dateFromNSDate:d]];
    }
    
    return days;
}

+ (NSDate *)dayInPreviousWeekForDay:(NSDate *)date
{
    NSDate *previousDate = [date cc_dateByMovingToFirstDayOfThePreviousWeek];
    return previousDate;
}

+ (NSDate *)dayInNextWeekForDay:(NSDate *)date
{
    NSDate *nextDate = [date cc_dateByMovingToFirstDayOfTheFollowingWeek];
    return nextDate;
}


//month

+ (NSDate *)firstDayInMonthForDate:(NSDate *)date
{
    NSDate *firstDayInMonth = [date cc_dateByMovingToFirstDayOfTheMonth];
    return firstDayInMonth;
}

+ (NSDate *)firstDayInPreviousMonthForDay:(NSDate *)date
{
    NSDate *previousDate = [date cc_dateByMovingToFirstDayOfThePreviousMonth];
    return previousDate;
}

+ (NSDate *)nextDayInNextMonthForDay:(NSDate *)date
{
    NSDate *previousDate = [date cc_dateByMovingToFirstDayOfTheFollowingMonth];
    return previousDate;
}

+ (NSUInteger)numberOfDaysInPreviousPartialWeekForDay:(NSDate *)date
{
    return [date cc_weekday] - 1;
}

+ (NSUInteger)numberOfDaysInFollowingPartialWeekForDay:(NSDate *)date
{
    NSDateComponents *c = [date cc_componentsForMonthDayAndYear];
    c.day = [date cc_numberOfDaysInMonth];
    NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
    return 7 - [lastDayOfTheMonth cc_weekday];
}

+ (NSArray *)daysInFinalWeekOfPreviousMonthForDay:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDate *beginningOfPreviousMonth = [date cc_dateByMovingToFirstDayOfThePreviousMonth];
    int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
    int numPartialDays = [KalLogicUtils numberOfDaysInPreviousPartialWeekForDay:date];
    NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
    for (int i = n - (numPartialDays - 1); i < n + 1; i++)
        [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

+ (NSArray *)daysInFirstWeekOfFollowingMonthForDay:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSDateComponents *c = [[date cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
    NSUInteger numPartialDays = [KalLogicUtils numberOfDaysInFollowingPartialWeekForDay:date];
    for (int i = 1; i < numPartialDays + 1; i++)
        [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

+ (NSArray *)daysInSelectedMonthForDay:(NSDate *)date
{
    NSMutableArray *days = [NSMutableArray array];
    
    NSUInteger numDays = [date cc_numberOfDaysInMonth];
    NSDateComponents *c = [date cc_componentsForMonthDayAndYear];
    for (int i = 1; i < numDays + 1; i++)
        [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
    
    return days;
}

+ (NSArray *)visibleMonthDaysForDay:(NSDate *)date
{
    NSArray *daysInFinalWeekOfPreviousMonth = [self daysInFinalWeekOfPreviousMonthForDay:date];
    NSArray *daysInSelectedMonth = [self daysInSelectedMonthForDay:date];
    NSArray *daysInFirstWeekOfFollowingMonth = [self daysInFirstWeekOfFollowingMonthForDay:date];
    
//    KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
//    KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
//    self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
//    self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
    NSMutableArray *visibleDays = [NSMutableArray array];
    [visibleDays addObjectsFromArray:daysInFinalWeekOfPreviousMonth];
    [visibleDays addObjectsFromArray:daysInSelectedMonth];
    [visibleDays addObjectsFromArray:daysInFirstWeekOfFollowingMonth];
    
    return visibleDays;
}

+ (NSString *)selectedMonthNameAndYearForDay:(NSDate *)date
{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
    NSString *monthNameAndYear = [monthAndYearFormatter stringFromDate:date];
    [monthAndYearFormatter release];
    return monthNameAndYear;
}
@end
