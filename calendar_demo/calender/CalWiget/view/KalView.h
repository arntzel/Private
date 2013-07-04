#import <UIKit/UIKit.h>
#import "KalWeekGridView.h"
#import "KalGridView.h"

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

#define WEEK_MODE 0
#define MONTH_MODE 1
#define LIST_MODE 2

@interface KalView : UIView
{
    UILabel *headerTitleLabel;
    KalGridView *gridView;
    KalWeekGridView *weekGridView;
    id<KalViewDelegate> delegate;
    KalLogic *logic;
    
    NSInteger KalMode;
}
@property (nonatomic, assign) NSInteger KalMode;
@property (nonatomic, assign) id<KalViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate;

- (void)swapToWeekMode;
- (void)swapToMonthMode;

- (void)setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;

- (CGFloat)weekViewHeight;

- (void)delayGestureResponse:(UIGestureRecognizer *)gesture;

@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate
@optional
- (void)monthModeToEventMode;
- (void)eventModeToMontMode;
- (void)showListView;

- (void)didSelectDate:(KalDate *)date;
@end
