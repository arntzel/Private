#import <UIKit/UIKit.h>
#import "KalWeekGridView.h"
#import "CalendarIntegrationView.h"
@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

@interface KalView : UIView
{
    UILabel *headerTitleLabel;
    KalGridView *gridView;
    KalWeekGridView *weekGridView;
    UIImageView *shadowView;
    id<KalViewDelegate> delegate;
    KalLogic *logic;
}

@property (nonatomic, assign) id<KalViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate;
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
