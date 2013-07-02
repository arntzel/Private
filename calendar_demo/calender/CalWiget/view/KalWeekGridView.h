
#import <UIKit/UIKit.h>

#import "KalWeekView.h"

@class KalTileView, KalLogic, KalDate;


@protocol KalWeekGridViewDelegate <NSObject>
@required
- (void)didSelectDate:(KalDate *)date;
@end


@interface KalWeekGridView : UIView
{
    id<KalWeekGridViewDelegate> delegate;  // Assigned.
    KalLogic *logic;
    KalWeekView *frontWeekView;
    KalWeekView *backWeekView;
    KalTileView *selectedTile;
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
}

@property (nonatomic, readonly) KalDate *selectedDate;
@property (nonatomic, readonly) KalWeekView *frontWeekView;
@property (nonatomic, readonly) KalWeekView *backWeekView;
@property (nonatomic, assign) UISwipeGestureRecognizer *oneFingerSwipeLeft;
@property (nonatomic, assign) UISwipeGestureRecognizer *oneFingerSwipeRight;


- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalWeekGridViewDelegate>)delegate;

- (void)slideLeft;
- (void)slideRight;
- (void)jumpToSelectedWeek;    // see comment on KalView
@end
