/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalTileView.h"

@class KalTileView, KalMonthView, KalLogic, KalDate;
@protocol KalViewDelegate;

/*
 *    KalGridView
 *    ------------------
 *
 *    Private interface
 *
 *  As a client of the Kal system you should not need to use this class directly
 *  (it is managed by KalView).
 *
 */

@protocol KalGridViewDelegate <NSObject>
@required

- (void)showPreviousMonth;
- (void)showFollowingMonth;
- (void)didSelectDate:(KalDate *)date;
- (KalDate *)selectedDate;
@end


@interface KalGridView : UIView
{
  id<KalGridViewDelegate> delegate;  // Assigned.
  KalLogic *logic;
  KalMonthView *frontMonthView;
  KalMonthView *backMonthView;
  KalTileView *selectedTile;
  KalTileView *highlightedTile;
  BOOL transitioning;
}

@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, readonly) KalMonthView * frontMonthView;
@property (nonatomic, readonly) KalMonthView * backMonthView;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalGridViewDelegate>)delegate;
- (void)selectDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;

// These 3 methods should be called *after* the KalLogic
// has moved to the previous or following month.
- (void)slideRight;
- (void)slideLeft;
- (void)jumpToSelectedMonth;    // see comment on KalView

@end
