//
//  FeedCalenderView.m
//  calender
//
//  Created by zyax86 on 13-7-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "FeedCalenderView.h"
#import "CalendarIntegrationView.h"

@interface FeedCalenderView()<UIGestureRecognizerDelegate>
{
    UIScrollView *eventScrollView;
    KalView *kalView;
    
    CGPoint lastPanPoint;
    CGRect orgFrame;
}

@end

extern const CGSize kTileSize;

@implementation FeedCalenderView

- (void)dealloc
{
    [kalView removeObserver:self forKeyPath:@"frame"];
    [eventScrollView release];
    [kalView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    self = [super initWithFrame:frame];
    if (self) {
        kalView = [[KalView alloc] initWithFrame:self.bounds delegate:theDelegate logic:theLogic selectedDate:_selectedDate];
        [kalView swapToWeekMode];
        [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:kalView];
        
        [self addeventScrollView];
        [self addPanGestureRecognizer];
    }
    return self;
}

- (void)addeventScrollView
{
    eventScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    CalendarIntegrationView *listView = [CalendarIntegrationView createCalendarIntegrationView];
    [self addSubview:eventScrollView];
    [eventScrollView addSubview:listView];
    [eventScrollView setContentSize:listView.frame.size];
    [eventScrollView setScrollEnabled:YES];
    [eventScrollView setShowsHorizontalScrollIndicator:YES];
    [eventScrollView setBounces:NO];
    [self ajustEventScrollPosition];
}

- (void)ajustEventScrollPosition
{
    [eventScrollView setFrame:CGRectMake(0, kalView.frame.size.height, self.bounds.size.width, 100)];
    
    CGRect frame = self.frame;
    frame.size.height = kalView.frame.size.height + eventScrollView.frame.size.height;
    [self setFrame:frame];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self ajustEventScrollPosition];
    }
}



-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
    [panGesture release];
    [kalView delayGestureResponse:panGesture];
}


- (void)panGesture:(UIPanGestureRecognizer *)pan
{

    CGPoint point = [pan locationInView:self.superview];
    CGFloat animationDuring = 0.2f;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    if (pan.state==UIGestureRecognizerStateBegan) {
        lastPanPoint = point;
        if (kalView.KalMode == WEEK_MODE)
        {
            [kalView swapToMonthMode];
        }
        orgFrame = self.frame;
    }
    else if (pan.state==UIGestureRecognizerStateChanged) {
        CGFloat yOffset = point.y - lastPanPoint.y;
        CGRect frame = self.frame;
        frame.origin.y += yOffset;
        self.frame = frame;
        
        lastPanPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled)
    {
        [kalView swapToWeekMode];
        self.frame = orgFrame;
    }

    
    
    
    /*
    if (pan.state==UIGestureRecognizerStateBegan) {
        lastPanPoint = point;
        if (KalMode == WEEK_MODE)
        {
            [gridView jumpToSelectedMonth];
            [self hideViewWithAlphaAnimation:weekGridView];
        }
        else if(KalMode == MONTH_MODE)
        {
            [weekGridView jumpToSelectedWeek];
        }
        orgFrame = self.frame;
    }
    else if (pan.state==UIGestureRecognizerStateChanged) {
        CGFloat yOffset = point.y - lastPanPoint.y;
        if (KalMode == WEEK_MODE)
        {
            CGRect frame = self.frame;
            frame.origin.y += yOffset;
            
            if (frame.origin.y > orgFrame.origin.y) {
                self.frame = orgFrame;
            }
            else
            {
                self.frame = frame;
            }
        }
        else if(KalMode == MONTH_MODE)
        {
            CGRect frame = self.frame;
            frame.origin.y += yOffset;
            
            if (frame.origin.y < orgFrame.origin.y) {
                self.frame = orgFrame;
            }
            else
            {
                self.frame = frame;
            }
        }
        lastPanPoint = point;
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled)
    {
        CGRect frame = self.frame;
        
        if (KalMode == WEEK_MODE)
        {
            if (orgFrame.origin.y - frame.origin.y > weekGridView.frame.size.height) {
                self.userInteractionEnabled = NO;
                [UIView animateWithDuration:animationDuring animations:^{
                    [self setFrameToMonthMode];
                    [weekGridView setFrame:CGRectMake(0 , gridView.height + headerView.height, self.frame.size.width, weekGridView.height)];
                } completion:^(BOOL finished){
                    self.userInteractionEnabled = YES;
                    [self hideViewWithAlphaAnimation:weekGridView];
                    //                    [weekGridView setHidden:YES];
                    KalMode = MONTH_MODE;
                }];
            }
            else
            {
                self.userInteractionEnabled = NO;
                [UIView animateWithDuration:animationDuring animations:^{
                    self.frame = orgFrame;
                } completion:^(BOOL finished){
                    self.userInteractionEnabled = YES;
                    [self showViewWithAlphaAnimation:weekGridView];
                    //                    [weekGridView setHidden:NO];
                }];
            }
        }
        else if(KalMode == MONTH_MODE)
        {
            if (frame.origin.y - orgFrame.origin.y > weekGridView.frame.size.height)
            {
                self.userInteractionEnabled = NO;
                [UIView animateWithDuration:animationDuring animations:^{
                    [self setFrameToWeekMode];
                    [weekGridView setFrame:CGRectMake(0 ,0, self.frame.size.width, weekGridView.height)];
                } completion:^(BOOL finished){
                    self.userInteractionEnabled = YES;
                    KalMode = WEEK_MODE;
                    //                    [weekGridView setHidden:NO];
                    [self showViewWithAlphaAnimation:weekGridView];
                }];
            }
            else
            {
                self.userInteractionEnabled = NO;
                [UIView animateWithDuration:animationDuring animations:^{
                    self.frame = orgFrame;
                } completion:^(BOOL finished){
                    self.userInteractionEnabled = YES;
                }];
            }
        }
    }
*/
}

-(void) setNeedsDisplay
{
    [super setNeedsDisplay];
    [kalView setNeedsDisplay];
}

-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource
{
    [kalView setKalTileViewDataSource:datasource];
}
@end
