
#import <Foundation/Foundation.h>

#import "KalDate.h"
#import "KalPrivate.h"

@interface KalLogicUtils : NSObject

//week
+ (NSArray *)visibleWeekDaysForDay:(NSDate *)date;

+ (NSDate *)dayInPreviousWeekForDay:(NSDate *)date;

+ (NSDate *)dayInNextWeekForDay:(NSDate *)date;


//month
+ (NSDate *)firstDayInMonthForDate:(NSDate *)date;

+ (NSDate *)firstDayInPreviousMonthForDay:(NSDate *)date;

+ (NSDate *)nextDayInNextMonthForDay:(NSDate *)date;

+ (NSUInteger)numberOfDaysInPreviousPartialWeekForDay:(NSDate *)date;

+ (NSUInteger)numberOfDaysInFollowingPartialWeekForDay:(NSDate *)date;

+ (NSArray *)daysInFinalWeekOfPreviousMonthForDay:(NSDate *)date;

+ (NSArray *)daysInFirstWeekOfFollowingMonthForDay:(NSDate *)date;

+ (NSArray *)daysInSelectedMonthForDay:(NSDate *)date;

+ (NSArray *)visibleMonthDaysForDay:(NSDate *)date;

+ (NSString *)selectedMonthNameAndYearForDay:(NSDate *)date;
@end
