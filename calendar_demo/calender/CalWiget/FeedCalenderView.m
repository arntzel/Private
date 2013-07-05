#import "FeedCalenderView.h"
#import "CalendarIntegrationView.h"
#import "DeviceInfo.h"

#define weekViewHeight 65

@interface FeedCalenderView()<UIGestureRecognizerDelegate>
{
    UIScrollView *eventScrollView;
    KalView *kalView;
    
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

- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    CGRect frame = CGRectMake(0, [DeviceInfo fullScreenHeight] - weekViewHeight, 320, 40);
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

- (void)setFrameToWeekMode
{
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - weekViewHeight;
    self.frame = frame;
}

- (void)setFrameToMonthMode
{
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - kalView.frame.size.height;
    self.frame = frame;
}

- (void)setFrameToFilterMode
{
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - self.frame.size.height;
    self.frame = frame;
}

- (void)ajustEventScrollPosition
{
    CGFloat height = [DeviceInfo fullScreenHeight] - kalView.frame.size.height - 100;
    [eventScrollView setFrame:CGRectMake(0, kalView.frame.size.height, self.bounds.size.width, height)];
    
    CGRect frame = self.frame;
    frame.size.height = kalView.frame.size.height + eventScrollView.frame.size.height;
    self.frame = frame;
}

- (void)animationWithBlock:(void (^)(void))block Completion:(void (^)(void))completion
{
    [UIView animateWithDuration:0.3 animations:block completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
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
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (kalView.KalMode == WEEK_MODE)
        {
            [kalView swapToMonthMode];
        }
        orgFrame = self.frame;
    }
    else if (pan.state==UIGestureRecognizerStateChanged)
    {
        CGPoint transPoint = [pan translationInView:self];
        CGRect frame = orgFrame;
        frame.origin.y += transPoint.y;
        if (frame.origin.y + frame.size.height < [DeviceInfo fullScreenHeight]) {
            [self setFrameToFilterMode];
        }
        else if(frame.origin.y > [DeviceInfo fullScreenHeight] - weekViewHeight)
        {
            [self setFrameToWeekMode];
        }
        else
        {
            self.frame = frame;
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint testPoint = CGPointMake(eventScrollView.frame.size.width / 2, eventScrollView.frame.origin.y + eventScrollView.frame.size.height / 2);
        CGPoint pointAfterTransf = [self convertPoint:testPoint toView:self.superview];
        if (pointAfterTransf.y < [DeviceInfo fullScreenHeight]) {
            [self animationWithBlock:^{
                [self setFrameToFilterMode];
            } Completion:nil];
            return;
        }
    
        testPoint = CGPointMake(kalView.frame.size.width / 2, kalView.frame.origin.y + kalView.frame.size.height / 2);
        pointAfterTransf = [self convertPoint:testPoint toView:self.superview];
        if (pointAfterTransf.y < [DeviceInfo fullScreenHeight]) {
            [self animationWithBlock:^{
                [self setFrameToMonthMode];
            } Completion:nil];
            return;
        }
        else
        {
            [self animationWithBlock:^{
                [self setFrameToWeekMode];
            } Completion:^{
                [kalView swapToWeekMode];
            }];
            return;
        }
    }
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
