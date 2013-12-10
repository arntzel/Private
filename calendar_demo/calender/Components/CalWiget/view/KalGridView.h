
#import <UIKit/UIKit.h>
#import "KalTileView.h"

@class KalTileView, KalMonthView, KalLogic, KalDate;
@protocol KalViewDelegate;

@protocol KalGridViewDelegate <NSObject>
@required
- (void)didSelectDate:(KalDate *)date;
- (void)willShowMonth:(KalDate *)date;
@end


@interface KalGridView : UIView
{
  id<KalGridViewDelegate> delegate;  // Assigned.
    id<KalViewDelegate> viewDelegate;
  KalLogic *logic;
  KalMonthView *frontMonthView;
  KalMonthView *backMonthView;
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
}

@property (nonatomic, readonly) KalMonthView * frontMonthView;
@property (nonatomic, readonly) KalMonthView * backMonthView;
@property (nonatomic, assign) BOOL enableMonthChange;
@property (nonatomic, assign) UISwipeGestureRecognizer *oneFingerSwipeLeft;
@property (nonatomic, assign) UISwipeGestureRecognizer *oneFingerSwipeRight; 

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalGridViewDelegate>)delegate;
- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalGridViewDelegate>)delegate viewDelegate:(id<KalViewDelegate>)delegate2;
- (void)slideRight;
- (void)slideLeft;
- (void)slide:(int)direction;

- (void)jumpToSelectedMonth;    // see comment on KalView

@end
