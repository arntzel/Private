//
//  KalWeekView.h
//  calTest
//
//  Created by zyax86 on 13-5-12.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KalTileView, KalDate;

@interface KalWeekView : UIView
- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates selectedDate:(KalDate *)_selectedDate;


- (KalTileView *)firstTileOfWeek;
- (KalTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;
@end
