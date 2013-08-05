#import "NSDateAdditions.h"

@implementation NSDate (KalAdditions)

- (NSDate *)cc_dateByMovingToBeginningOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:0];
  [parts setMinute:0];
  [parts setSecond:0];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  [parts setHour:23];
  [parts setMinute:59];
  [parts setSecond:59];
  return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
  NSDate *d = nil;
  BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
  NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
  return d;
}

////////////// add york
- (NSDate *)cc_dateByMovingToFirstDayOfTheWeek
{
    NSDate *d = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the week based on %@", self);
    return d;
}

- (NSDate *)cc_dateByMovingToEndDayOfTheWeek
{
    NSDate *d = [[self cc_dateByMovingToFirstDayOfTheFollowingWeek] cc_dateByMovingToThePreviousDayCout:1];
    return d;
}

- (NSDate *)cc_dateByMovingToThePreviousDayCout:(NSInteger )count
{
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    c.day = -count;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate *)cc_dateByMovingToTheFollowingDayCout:(NSInteger )count
{
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    c.day = count;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousWeek
{
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    c.day = -7;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingWeek
{
    NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
    c.day = 7;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}
/////////////

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.month = -1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];  
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
  NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
  c.month = 1;
  return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
  return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_weekday
{
  return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
  return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

-(int) compareWeek:(NSDate *) date
{

    NSDate  * weekBegin = [self cc_dateByMovingToFirstDayOfTheWeek];
    NSDate  * weekBegin2 = [date cc_dateByMovingToFirstDayOfTheWeek];
    
    return [weekBegin compare:weekBegin2];
}

-(NSInteger) cc_DaysBetween:(NSDate *) date
{
    NSDate * selfDay = [self cc_dateByMovingToBeginningOfDay];
    NSDate * day = [date cc_dateByMovingToBeginningOfDay];

    return (NSInteger)([day timeIntervalSinceDate:selfDay]/(3600*24));
}

@end