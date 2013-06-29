/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalWeekGridView.h"
#import "CalendarIntegrationView.h"
#import "KalGridView.h"

@class KalGridView, KalLogic, KalDate;
@protocol KalViewDelegate, KalDataSourceCallbacks;

/*
 *    KalView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalViewController).
 *
 *  KalViewController uses KalView as its view.
 *  KalView defines a view hierarchy that looks like the following:
 *
 *       +-----------------------------------------+
 *       |                header view              |
 *       +-----------------------------------------+
 *       |                                         |
 *       |                                         |
 *       |                                         |
 *       |                 grid view               |
 *       |             (the calendar grid)         |
 *       |                                         |
 *       |                                         |
 *       +-----------------------------------------+
 *
 */
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
@property (nonatomic, retain) KalDate *selectedDate;



- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)logic selectedDate:(KalDate*)_selectedDate;
- (BOOL)isSliding;
- (void)markTilesForDates:(NSArray *)dates;
- (void)redrawEntireMonth;

// These 3 methods are exposed for the delegate. They should be called 
// *after* the KalLogic has moved to the month specified by the user.
- (void)slideLeft;
- (void)slideRight;
- (void)jumpToSelectedMonth;    // change months without animation (i.e. when directly switching to "Today")

-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;

@end

#pragma mark -

@class KalDate;

@protocol KalViewDelegate
@optional
- (void)monthModeToEventMode;
- (void)eventModeToMontMode;

- (void)showPreviousWeek;
- (void)showFollowingWeek;

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate *)date;

- (void)showListView;

@end
