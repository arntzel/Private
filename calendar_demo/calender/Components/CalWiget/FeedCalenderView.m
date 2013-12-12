#import "FeedCalenderView.h"
#import "EventFilterView.h"
#import "DeviceInfo.h"
#import "FeedViewController.h"

#define weekViewHeight 65
#define topGap 100

@interface FeedCalenderView()
{
    UIScrollView *eventScrollView;
    
    CGRect orgFrame;
    
    NSInteger kalMode;
}

@end

extern const CGSize kTileSize;

@implementation FeedCalenderView

@synthesize kalView;

- (void)dealloc
{
    [kalView removeObserver:self forKeyPath:@"frame"];
    [eventScrollView release];
    
    self.kalView = nil;
    self.filterView = nil;
    
    [super dealloc];
}

- (id)initWithdelegate:(id<KalViewDelegate>)theDelegate controllerDelegate:(id<FeedViewControllerDelegate>) theCtlDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    self.controllerDelegate = theCtlDelegate;
    self = [self initWithdelegate:theDelegate logic:theLogic selectedDate:_selectedDate];
    return self;
}

- (id)initWithdelegate:(id<KalViewDelegate,UIGestureRecognizerDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    CGRect frame = CGRectMake(0, [DeviceInfo fullScreenHeight] - weekViewHeight, 320, 40);
    return [self initWithFrame:frame delegate:theDelegate logic:theLogic selectedDate:_selectedDate];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate,UIGestureRecognizerDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    self = [super initWithFrame:frame];
    if (self) {
        kalView = [[KalView alloc] initWithFrame:frame delegate:theDelegate controllerDelegate:self.controllerDelegate logic:theLogic selectedDate:_selectedDate];
        [kalView swapToWeekMode];
        kalMode = WEEK_MODE;
        kalView.calendarDelegate = self;
        [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:kalView];
        
        [self addeventScrollView];
        [self addPanGestureRecognizer:theDelegate];
    }
    return self;
}

- (void)addeventScrollView
{
    eventScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.filterView = [[EventFilterView alloc] init];
    
    [self addSubview:eventScrollView];
    [eventScrollView addSubview:self.filterView];
    [eventScrollView setContentSize:self.filterView.frame.size];
    [eventScrollView setScrollEnabled:YES];
    [eventScrollView setShowsHorizontalScrollIndicator:YES];
    [eventScrollView setBounces:NO];
    eventScrollView.backgroundColor = [UIColor whiteColor];
    [self ajustEventScrollPosition];
}

- (void)updateFilterFrame
{
    [eventScrollView setContentSize:self.filterView.frame.size];
}


-(void)onSetToFilterMode
{
    [self animationWithBlock:^{
        [self setFrameToFilterMode];
    } Completion:^{
        kalMode = FILTER_MODE;
    }];
}

- (void)setFrameToWeekMode
{
    [[self controllerDelegate] unloadBlurBackground];
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - weekViewHeight;
    self.frame = frame;
}

- (void)setFrameToMonthMode
{
    [[self controllerDelegate] unloadBlurBackground];
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - kalView.frame.size.height;
    self.frame = frame;
}

- (void)setFrameToFilterMode
{
    [[self controllerDelegate] blurBackground];
    CGRect frame = self.frame;
    frame.origin.y = [DeviceInfo fullScreenHeight] - self.frame.size.height;
    self.frame = frame;
}

- (void)ajustEventScrollPosition
{
    [eventScrollView setFrame:CGRectMake(0, kalView.frame.size.height, self.bounds.size.width, [self.filterView displayHeight])];
    
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
    if ([keyPath isEqualToString:@"frame"] && (object == kalView)) {
        [eventScrollView setFrame:CGRectMake(0, kalView.frame.size.height, self.bounds.size.width, [self.filterView displayHeight])];
        CGRect frame = self.frame;
        frame.size.height = kalView.frame.size.height + eventScrollView.frame.size.height;
        
        if (kalMode == MONTH_MODE) {
            frame.origin.y = [DeviceInfo fullScreenHeight] - kalView.frame.size.height;
        }
        if (kalMode == FILTER_MODE) {
            frame.origin.y = [DeviceInfo fullScreenHeight] - kalView.frame.size.height - eventScrollView.frame.size.height;
        }
        self.frame = frame;
    }
}

-(void)addPanGestureRecognizer:(id<UIGestureRecognizerDelegate>)delegate
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [panGesture setDelegate:delegate];
    [self addGestureRecognizer:panGesture];
    [panGesture release];
    [kalView delayGestureResponse:panGesture];
}


- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    //[self.controllerDelegate blurBackground];
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (kalView.KalMode == WEEK_MODE)
        {
            //[self.controllerDelegate unloadBlurBackground];
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
            //[[self controllerDelegate] blurBackground];
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
            } Completion:^{
                kalMode = FILTER_MODE;
            }];
        }
        else
        {
            testPoint = CGPointMake(kalView.frame.size.width / 2, kalView.frame.origin.y + kalView.frame.size.height / 2);
            pointAfterTransf = [self convertPoint:testPoint toView:self.superview];
            if (pointAfterTransf.y < [DeviceInfo fullScreenHeight]) {
                [self animationWithBlock:^{
                    [self setFrameToMonthMode];
                } Completion:^{
                    kalMode = MONTH_MODE;
                }];
            }
            else
            {
                [kalView removeObserver:self forKeyPath:@"frame"];
                [self animationWithBlock:^{
                    [self setFrameToWeekMode];
                } Completion:^{
                    [kalView swapToWeekMode];
                    kalMode = WEEK_MODE;
                    [kalView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
                }];
            }
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
