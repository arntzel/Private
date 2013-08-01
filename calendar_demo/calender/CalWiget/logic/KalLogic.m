
#import "KalLogic.h"
#import "KalPrivate.h"
#import "KalLogicUtils.h"

@interface KalLogic ()

@end

@implementation KalLogic
@synthesize showMonth;
@synthesize selectedDay;
@synthesize showWeek;

- (void) dealloc
{
    self.showMonth = nil;
    self.selectedDay = nil;
    self.showWeek = nil;
    [super dealloc];
}

- (id)init
{
    return [self initForDate:[NSDate date]];
}

- (id)initForDate:(NSDate *)date
{
    if ((self = [super init])) {
        self.showMonth = [KalDate dateFromNSDate:[date cc_dateByMovingToFirstDayOfTheMonth]];
        self.showWeek = [KalDate dateFromNSDate:[date cc_dateByMovingToFirstDayOfTheWeek]];
        self.selectedDay = [KalDate dateFromNSDate:date];
    }
    return self;
}

//week
- (void)retreatToPreviousWeek
{
    NSDate *date = [[showWeek NSDate] cc_dateByMovingToFirstDayOfThePreviousWeek];
    self.showWeek = [KalDate dateFromNSDate:date];
}

- (void)advanceToFollowingWeek
{
    NSDate *date = [[showWeek NSDate] cc_dateByMovingToFirstDayOfTheFollowingWeek];
    self.showWeek = [KalDate dateFromNSDate:date];
}

-(void) showDate:(NSDate *) date
{
    date = [date cc_dateByMovingToFirstDayOfTheWeek];
    self.showWeek = [KalDate dateFromNSDate:date];
    
    date = [date cc_dateByMovingToFirstDayOfTheMonth];
    self.showMonth = [KalDate dateFromNSDate:date];
}

- (NSArray *)daysInShowingWeek
{
    NSArray *daysInShowingWeek = [KalLogicUtils visibleWeekDaysForDay:[showWeek NSDate]];
    return daysInShowingWeek;
}

- (void)ajustShowWeek
{
    if ((self.selectedDay.year == self.showMonth.year) &&
        self.selectedDay.month == self.showMonth.month) {
        NSDate *date = [[self.selectedDay NSDate] cc_dateByMovingToFirstDayOfTheWeek];
        self.showWeek= [KalDate dateFromNSDate:date];
    }
    else
    {
        NSDate *date = [[self.showMonth NSDate] cc_dateByMovingToFirstDayOfTheWeek];
        self.showWeek = [KalDate dateFromNSDate:date];
    }
}
//month
- (void)retreatToPreviousMonth
{
    NSDate *date = [[showMonth NSDate] cc_dateByMovingToFirstDayOfThePreviousMonth];
    self.showMonth = [KalDate dateFromNSDate:date];
}

- (void)advanceToFollowingMonth
{
    NSDate *date = [[showMonth NSDate] cc_dateByMovingToFirstDayOfTheFollowingMonth];
    self.showMonth = [KalDate dateFromNSDate:date];
}

- (NSArray *)daysInShowingMonth
{
    NSArray *daysInShowingMonth = [KalLogicUtils daysInSelectedMonthForDay:[showMonth NSDate]];
    return daysInShowingMonth;
}

- (NSArray *)daysInFinalWeekOfPreviousMonth
{
    NSArray *daysInFinalWeekOfPreviousMonth = [KalLogicUtils daysInFinalWeekOfPreviousMonthForDay:[showMonth NSDate]];
    return daysInFinalWeekOfPreviousMonth;
}

- (NSArray *)daysInFirstWeekOfFollowingMonth
{
    NSArray *daysInFirstWeekOfFollowingMonth = [KalLogicUtils daysInFirstWeekOfFollowingMonthForDay:[showMonth NSDate]];
    return daysInFirstWeekOfFollowingMonth;
}

- (void)ajustShowMonth
{
    NSDate *date = [self.showWeek NSDate];
    KalDate *dayInWeekend = [KalDate dateFromNSDate:[date cc_dateByMovingToEndDayOfTheWeek]];
    
    if ((self.selectedDay.year == dayInWeekend.year) &&
        self.selectedDay.month == dayInWeekend.month) {
        NSDate *date = [[self.selectedDay NSDate] cc_dateByMovingToFirstDayOfTheMonth];
        self.showMonth = [KalDate dateFromNSDate:date];
    }
    else
    {
        NSDate *date = [[[self.showWeek NSDate] cc_dateByMovingToFirstDayOfTheFollowingWeek ] cc_dateByMovingToFirstDayOfTheMonth];
        self.showMonth = [KalDate dateFromNSDate:date];
    }
}

@end
