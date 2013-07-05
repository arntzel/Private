//
//  AddDateCalenderView.m
//  calender
//
//  Created by zyax86 on 13-7-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddDateCalenderView.h"
#import "DeviceInfo.h"

@interface AddDateCalenderView()
{
    KalView *kalView;
}

@end

@implementation AddDateCalenderView

- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    CGRect frame = CGRectMake(0, 0, 320, 40);
    return [self initWithFrame:frame delegate:theDelegate logic:theLogic selectedDate:_selectedDate];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    self = [super initWithFrame:frame];
    if (self) {
        kalView = [[KalView alloc] initWithFrame:self.bounds delegate:theDelegate logic:theLogic selectedDate:_selectedDate];
        [kalView swapToWeekMode];
        [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:kalView];
        [self addDateTypeView];
    }
    return self;
}

- (void)addDateTypeView
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self ajustEventScrollPosition];
    }
}

- (void)ajustEventScrollPosition
{

}
@end
