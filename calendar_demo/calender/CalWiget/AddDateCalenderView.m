//
//  AddDateCalenderView.m
//  calender
//
//  Created by zyax86 on 13-7-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "AddDateCalenderView.h"
#import "DeviceInfo.h"
#import "AddDateTypeView.h"

@interface AddDateCalenderView()
{
    KalView *kalView;
    AddDateTypeView *typeView;
}

@end

@implementation AddDateCalenderView
@synthesize delegate;

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
        [kalView swapToMonthMode];
        [self addSubview:kalView];
        [self addDateTypeView];
        [self ajustViewFrame];
        
        [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)ajustViewFrame
{
    CGFloat height = [DeviceInfo fullScreenHeight];
    
    CGRect frame = self.frame;
    frame.size.height = typeView.frame.size.height + kalView.frame.size.height;
    frame.origin.y = height - frame.size.height;
    self.frame = frame;

    frame = typeView.frame;
    frame.origin.y = kalView.frame.size.height;
    typeView.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"] && (object == kalView)) {
        [self ajustViewFrame];
    }
}

- (void)addDateTypeView
{
    typeView = [AddDateTypeView createView];
    [self addSubview:typeView];
    [typeView.btnChooseTime addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [typeView.btnChooseDuration addTarget:self action:@selector(chooseDurationAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseTimeAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chooseTimeAction)])
    {
        [self.delegate chooseTimeAction];
    }
}

- (void)chooseDurationAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chooseDurationAction)])
    {
        [self.delegate chooseDurationAction];
    }
}

- (void)setStartTimeString:(NSString *)string
{
    typeView.startTimeLabel.text = string;
}

- (void)setDuringTimeString:(NSString *)string
{
    typeView.duringTimeLabel.text = string;
}

-(KalView *) getKalView
{
    return kalView;
}
@end
