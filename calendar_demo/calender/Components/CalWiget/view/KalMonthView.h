
#import <UIKit/UIKit.h>
#import "KalView.h"
@class KalTileView, KalDate;
@protocol KalViewDelegate;
@interface KalMonthView : UIView
{
    id<KalViewDelegate> delegate;
    NSUInteger numWeeks;
    //KalActionsView *actionsView;
}

@property (nonatomic) NSUInteger numWeeks;
//@property (assign, nonatomic) KalActionsView *actionsView;

- (id)initWithFrame:(CGRect)rect; // designated initializer
- (id)initWithFrame:(CGRect)rect withDelegate:(id<KalViewDelegate>)theDelegate;
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates selectedDate:(KalDate *)_selectedDate;
- (void)clearSelectedState;

-(void) setSelectedDate:(KalDate *)_selectedDate;

- (KalTileView *)tileForDate:(KalDate *)date;

@end
