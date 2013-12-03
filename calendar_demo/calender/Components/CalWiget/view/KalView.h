#import <UIKit/UIKit.h>
#import "KalWeekGridView.h"

#import "KalGridView.h"

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

#define WEEK_MODE 0
#define MONTH_MODE 1
#define FILTER_MODE 2

@interface KalView : UIView
{
    UILabel *headerTitleLabel;
    KalGridView *gridView;
    KalWeekGridView *weekGridView;
    NSObject<KalViewDelegate> *delegate;
    KalLogic *logic;
    
    NSInteger KalMode;
}
@property (nonatomic, assign) NSInteger KalMode;
@property (nonatomic, assign) NSObject<KalViewDelegate> *delegate;

- (id)initWithFrame:(CGRect)frame delegate:(NSObject<KalViewDelegate> *)theDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate;

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
@end
