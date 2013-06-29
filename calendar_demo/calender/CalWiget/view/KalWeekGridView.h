//
//  KalWeekGridView.h
//  calTest
//
//  Created by zyax86 on 13-5-12.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//



#import <UIKit/UIKit.h>

#import "KalWeekView.h"

@class KalTileView, KalLogic, KalDate;


@protocol KalWeekGridViewDelegate <NSObject>
@required

- (void)showPreviousWeek;
- (void)showFollowingWeek;

- (void)didSelectDate:(KalDate *)date;

- (KalDate *)selectedDate;
@end


@interface KalWeekGridView : UIView
{
    id<KalWeekGridViewDelegate> delegate;  // Assigned.
    KalLogic *logic;
    KalWeekView *frontWeekView;
    KalWeekView *backWeekView;
    KalTileView *selectedTile;
    KalTileView *highlightedTile;
    BOOL transitioning;
}

@property (nonatomic, readonly) BOOL transitioning;
@property (nonatomic, readonly) KalDate *selectedDate;

@property (nonatomic, readonly) KalWeekView *frontWeekView;
@property (nonatomic, readonly) KalWeekView *backWeekView;


- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)logic delegate:(id<KalWeekGridViewDelegate>)delegate;
- (void)selectDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;


- (void)slideLeft;
- (void)slideRight;

- (void)jumpToSelectedWeek;    // see comment on KalView
@end
