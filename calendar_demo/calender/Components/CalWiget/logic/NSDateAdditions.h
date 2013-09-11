#import <Foundation/Foundation.h>

@interface NSDate (KalAdditions)

// All of the following methods use [NSCalendar currentCalendar] to perform
// their calculations.


////////////// add york
- (NSDate *)cc_dateByMovingToThePreviousDayCout:(NSInteger )count;
- (NSDate *)cc_dateByMovingToTheFollowingDayCout:(NSInteger )count;

- (NSDate *)cc_dateByMovingToFirstDayOfTheWeek;
- (NSDate *)cc_dateByMovingToEndDayOfTheWeek;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousWeek;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingWeek;



- (NSDate *)cc_dateByMovingToBeginningOfDay;
- (NSDate *)cc_dateByMovingToEndOfDay;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;


-(NSInteger) cc_DaysBetween:(NSDate *) date;


-(int) compareWeek:(NSDate *) date;

@end