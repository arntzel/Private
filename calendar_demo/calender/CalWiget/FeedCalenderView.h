//
//  FeedCalenderView.h
//  calender
//
//  Created by zyax86 on 13-7-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"

@interface FeedCalenderView : UIView

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate;
-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource;

@end
