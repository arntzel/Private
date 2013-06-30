
#import <UIKit/UIKit.h>
#import "KalTileView.h"

@class KalTileView, KalMonthView, KalLogic, KalDate;
@protocol KalViewDelegate;

@protocol KalGridViewDelegate <NSObject>
@required
- (void)didSelectDate:(KalDate *)date;
@end


@interface KalGridView : UIView
{
  id<KalGridViewDelegate> delegate;  // Assigned.
  KalLogic *logic;
  KalMonthView *frontMonthView;
  KalMonthView *backMonthView;
}

@property (nonatomic, readonly) KalMonthView * frontMonthView;
@property (nonatomic, readonly) KalMonthView * backMonthView;
@property (nonatomic, assign) BOOL enableMonthChange;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalGridViewDelegate>)delegate;

- (void)slideRight;
- (void)slideLeft;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end
