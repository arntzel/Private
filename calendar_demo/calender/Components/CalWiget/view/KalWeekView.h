#import <UIKit/UIKit.h>

@class KalTileView, KalDate;

@interface KalWeekView : UIView
- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates selectedDate:(KalDate *)_selectedDate;

-(void) setSelectedDate:(KalDate *)_selectedDate;

- (void)clearSelectedState;
- (KalTileView *)tileForDate:(KalDate *)date;
@end
