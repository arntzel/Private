//
//  AddDateCalenderView.h
//  calender
//
//  Created by zyax86 on 13-7-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"

@protocol AddDateCalenderViewDelegate <NSObject>

- (void)chooseTimeAction;

- (void)chooseDurationAction;

@end

@interface AddDateCalenderView : UIView
- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate;

@property(nonatomic,assign) id<AddDateCalenderViewDelegate>delegate;

- (void)setStartTimeString:(NSString *)string;
- (void)setDuringTimeString:(NSString *)string;

@end
