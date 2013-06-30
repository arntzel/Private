
#import <Foundation/Foundation.h>
#import "KalDate.h"
@interface KalLogic : NSObject
{
    KalDate *showMonth;
    KalDate *selectedDay;
    KalDate *showWeek;
}

@property(nonatomic,retain) KalDate *showMonth;
@property(nonatomic,retain) KalDate *selectedDay;
@property(nonatomic,retain) KalDate *showWeek;

- (id)initForDate:(NSDate *)date;

//week
- (void)retreatToPreviousWeek;
- (void)advanceToFollowingWeek;
- (NSArray *)daysInShowingWeek;
- (void)ajustShowWeek;

//month
- (void)retreatToPreviousMonth;
- (void)advanceToFollowingMonth;
- (NSArray *)daysInShowingMonth;
- (NSArray *)daysInFinalWeekOfPreviousMonth;
- (NSArray *)daysInFirstWeekOfFollowingMonth;
- (void)ajustShowMonth;

@end
