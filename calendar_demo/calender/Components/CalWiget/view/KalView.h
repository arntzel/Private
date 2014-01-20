#import <UIKit/UIKit.h>
#import "KalWeekGridView.h"

#import "KalGridView.h"
#import "KalActionsView.h"
#import "UIViewAdditions.h"

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks, FeedViewControllerDelegate, FeedCalendarViewDelegate;

#define WEEK_MODE 0
#define MONTH_MODE 1
#define FILTER_MODE 2

@interface KalView : UIView
{
    UILabel *headerTitleLabel;
    KalGridView *gridView;
    KalWeekGridView *weekGridView;
    KalActionsView *actionsView;
    
    NSObject<KalViewDelegate> *delegate;
    id<FeedViewControllerDelegate> controllerDelegate;
    id<FeedCalendarViewDelegate> calendarDelegate;
    KalLogic *logic;
    
    BOOL hideActionBar;
    
    NSInteger KalMode;
}
@property (nonatomic, assign) NSInteger KalMode;
@property (nonatomic, assign) BOOL hideActionBar;
@property (nonatomic, assign) NSObject<KalViewDelegate> *delegate;
@property (nonatomic, assign) id<FeedViewControllerDelegate> controllerDelegate;
@property (nonatomic, assign) id<FeedCalendarViewDelegate> calendarDelegate;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject<KalViewDelegate> *)theDelegate controllerDelegate:(id<FeedViewControllerDelegate>) theCtrlDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate hideActionBar:(BOOL)hidden;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject<KalViewDelegate> *)theDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate hideActionBar:(BOOL)hidden;

//- (void)setActionBarHidden:(BOOL)hidden;

- (void)swapToWeekMode;
- (void)swapToMonthMode;

- (void)setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;

- (CGFloat)weekViewHeight;

- (void)delayGestureResponse:(UIGestureRecognizer *)gesture;

- (void) swith2Date:(NSDate *) date;

@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate
@optional
- (void)monthModeToEventMode;
- (void)eventModeToMontMode;
- (void)showListView;

- (void)didSelectDate:(KalDate *)date;
- (void)willShowMonth:(KalDate *)date;
- (void)willShowWeek:(KalDate *)date;

- (void)monthViewHeightChanged:(CGFloat)height;
- (void)showToday;
- (void)showCalendar;
@end
