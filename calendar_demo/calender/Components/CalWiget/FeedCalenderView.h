//
//  FeedCalenderView.h
//  calender
//
//  Created by zyax86 on 13-7-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"
#import "EventFilterView.h"


@interface FeedCalenderView : UIView

@property(retain, nonatomic) EventFilterView * filterView;
@property(retain, nonatomic) KalView *kalView;

- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate;
-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;
- (void)updateFilterFrame;

@end
