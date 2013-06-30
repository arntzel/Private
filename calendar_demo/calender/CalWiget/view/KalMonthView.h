
#import <UIKit/UIKit.h>

@class KalTileView, KalDate;

@interface KalMonthView : UIView
{
  NSUInteger numWeeks;
}

@property (nonatomic) NSUInteger numWeeks;

- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates selectedDate:(KalDate *)_selectedDate;
- (void)clearSelectedState;
- (KalTileView *)tileForDate:(KalDate *)date;

@end
