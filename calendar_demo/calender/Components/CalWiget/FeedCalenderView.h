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
//#import "KalActionsView.h"

//@protocol FeedViewControllerDelegate;
@protocol FeedCalendarViewDelegate <NSObject>

-(void)onSetToFilterMode;

@end
@interface FeedCalenderView : UIView <FeedCalendarViewDelegate>

@property(retain, nonatomic) EventFilterView * filterView;
@property(retain, nonatomic) KalView *kalView;
@property(nonatomic, assign) id<FeedViewControllerDelegate> controllerDelegate;
//@property(retain, nonatomic) KalActionsView *actionsView;

- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate;
- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate controllerDelegate:(id<FeedViewControllerDelegate>) theCtlDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate;
-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;
- (void)updateFilterFrame;
@end
