/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogic ()
- (void)moveToMonthForDate:(NSDate *)date;
- (void)recalculateVisibleDays;
- (NSUInteger)numberOfDaysInPreviousPartialWeek;
- (NSUInteger)numberOfDaysInFollowingPartialWeek;

@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;
@property (nonatomic, retain) NSArray *daysInSelectedMonth;
@property (nonatomic, retain) NSArray *daysInSelectedWeek;
@property (nonatomic, retain) NSArray *daysInFinalWeekOfPreviousMonth;
@property (nonatomic, retain) NSArray *daysInFirstWeekOfFollowingMonth;

@end

@implementation KalLogic

@synthesize baseDate,weekBaseDate, fromDate, toDate, daysInSelectedMonth, daysInSelectedWeek, daysInFinalWeekOfPreviousMonth, daysInFirstWeekOfFollowingMonth;

+ (NSSet *)keyPathsForValuesAffectingSelectedMonthNameAndYear
{
  return [NSSet setWithObjects:@"baseDate", nil];
}

- (id)initForDate:(NSDate *)date
{
  if ((self = [super init])) {
    monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"LLLL yyyy"];
    [self moveToMonthForDate:date];
      [self moveToWeekForDate:date];
  }
  return self;
}

- (id)init
{
  return [self initForDate:[NSDate date]];
}

//////////////////////  add
- (void)moveToWeekForDate:(NSDate *)date
{
    self.weekBaseDate = [date cc_dateByMovingToFirstDayOfTheWeek];
    self.baseDate = [self.weekBaseDate cc_dateByMovingToFirstDayOfTheMonth];
    [self recalculateCurrentWeekdays];
}

- (void)retreatToPreviousWeek
{
    NSDate *tempDate = [self.weekBaseDate cc_dateByMovingToFirstDayOfThePreviousWeek];
    [self moveToWeekForDate:tempDate];
}

- (void)advanceToFollowingWeek
{
    NSDate *tempDate = [self.weekBaseDate cc_dateByMovingToFirstDayOfTheFollowingWeek];
    [self moveToWeekForDate:tempDate];
}

- (void)recalculateCurrentWeekdays
{
    NSMutableArray *days = [NSMutableArray array];
    NSUInteger currentWeekDay = [self.weekBaseDate cc_weekday];
    
    NSLog(@"currentWeekDay :%d",currentWeekDay);
    for (NSUInteger index = currentWeekDay; index > 1; index--)
    {
        NSDate *d = [self.weekBaseDate cc_dateByMovingToFirstDayOfThePreviousDayCout:currentWeekDay - index];
        [days addObject:[KalDate dateFromNSDate:d]];
    }
    for (NSUInteger index = 7 ; index >= currentWeekDay; index--)
    {
        NSDate *d = [self.weekBaseDate cc_dateByMovingToFirstDayOfTheFollowingDayCout:7 - index];
        [days addObject:[KalDate dateFromNSDate:d]];
    }
    
    self.daysInSelectedWeek = days;
}
///////////////////////

- (void)moveToMonthForDate:(NSDate *)date
{
  self.baseDate = [date cc_dateByMovingToFirstDayOfTheMonth];
    self.weekBaseDate = [self.baseDate cc_dateByMovingToFirstDayOfTheWeek];
  [self recalculateVisibleDays];
}

- (void)retreatToPreviousMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth]];
}

- (void)advanceToFollowingMonth
{
  [self moveToMonthForDate:[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth]];
}

- (NSString *)selectedMonthNameAndYear;
{
  return [monthAndYearFormatter stringFromDate:self.baseDate];
}

#pragma mark Low-level implementation details

- (NSUInteger)numberOfDaysInPreviousPartialWeek
{
  return [self.baseDate cc_weekday] - 1;
}

- (NSUInteger)numberOfDaysInFollowingPartialWeek
{
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  c.day = [self.baseDate cc_numberOfDaysInMonth];
  NSDate *lastDayOfTheMonth = [[NSCalendar currentCalendar] dateFromComponents:c];
  return 7 - [lastDayOfTheMonth cc_weekday];
}

- (NSArray *)calculateDaysInFinalWeekOfPreviousMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
  int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
  int numPartialDays = [self numberOfDaysInPreviousPartialWeek];
  NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
  for (int i = n - (numPartialDays - 1); i < n + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInSelectedMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSUInteger numDays = [self.baseDate cc_numberOfDaysInMonth];
  NSDateComponents *c = [self.baseDate cc_componentsForMonthDayAndYear];
  for (int i = 1; i < numDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (NSArray *)calculateDaysInFirstWeekOfFollowingMonth
{
  NSMutableArray *days = [NSMutableArray array];
  
  NSDateComponents *c = [[self.baseDate cc_dateByMovingToFirstDayOfTheFollowingMonth] cc_componentsForMonthDayAndYear];
  NSUInteger numPartialDays = [self numberOfDaysInFollowingPartialWeek];
  
  for (int i = 1; i < numPartialDays + 1; i++)
    [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
  
  return days;
}

- (void)recalculateCurrentWeekDays
{
//    NSMutableArray *days = [NSMutableArray array];
//    
//    NSDate *beginningOfPreviousMonth = [self.baseDate cc_dateByMovingToFirstDayOfThePreviousMonth];
//    int n = [beginningOfPreviousMonth cc_numberOfDaysInMonth];
//    int numPartialDays = [self numberOfDaysInPreviousPartialWeek];
//    NSDateComponents *c = [beginningOfPreviousMonth cc_componentsForMonthDayAndYear];
//    for (int i = n - (numPartialDays - 1); i < n + 1; i++)
//        [days addObject:[KalDate dateForDay:i month:c.month year:c.year]];
//    
//    return days;
}

- (void)recalculateVisibleDays
{
  self.daysInSelectedMonth = [self calculateDaysInSelectedMonth];
  self.daysInFinalWeekOfPreviousMonth = [self calculateDaysInFinalWeekOfPreviousMonth];
  self.daysInFirstWeekOfFollowingMonth = [self calculateDaysInFirstWeekOfFollowingMonth];
  KalDate *from = [self.daysInFinalWeekOfPreviousMonth count] > 0 ? [self.daysInFinalWeekOfPreviousMonth objectAtIndex:0] : [self.daysInSelectedMonth objectAtIndex:0];
  KalDate *to = [self.daysInFirstWeekOfFollowingMonth count] > 0 ? [self.daysInFirstWeekOfFollowingMonth lastObject] : [self.daysInSelectedMonth lastObject];
  self.fromDate = [[from NSDate] cc_dateByMovingToBeginningOfDay];
  self.toDate = [[to NSDate] cc_dateByMovingToEndOfDay];
}

#pragma mark -

- (void) dealloc
{
  [monthAndYearFormatter release];
  [baseDate release];
    [weekBaseDate release];
  [fromDate release];
  [toDate release];
  [daysInSelectedMonth release];
  [daysInFinalWeekOfPreviousMonth release];
  [daysInFirstWeekOfFollowingMonth release];
  [super dealloc];
}

@end
