#import "KalView.h"
#import "KalGridView.h"
#import "KalMonthView.h"
#import "KalLogic.h"
#import "KalPrivate.h"

#define WEEK_MODE 0
#define MONTH_MODE 1
#define LIST_MODE 2

@interface KalView ()<UIGestureRecognizerDelegate,KalWeekGridViewDelegate,KalGridViewDelegate>
{
    UIView * _contentView;
    NSInteger KalMode;
    UIView *headerView;
    UIScrollView *eventView;
    
    CGPoint lastPanPoint;
    CGRect orgFrame;
}

- (void)addSubviewsToContentView:(UIView *)contentView;
@end

extern const CGSize kTileSize;
static const CGFloat kHeaderHeight = 20.0f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
        delegate = theDelegate;
        logic = [theLogic retain];
        [logic setSelectedDay:_selectedDate];

        headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
        headerView.backgroundColor = [UIColor grayColor];
        [self addSubviewsToHeaderView];
        [self addSubview:headerView];

        UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView:contentView];
        [self addSubview:contentView];

        _contentView = contentView;

//        [self addUISwipGestureRecognizer];
        [self addPanGestureRecognizer];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
    return nil;
}

- (void)addSubviewsToHeaderView
{
    NSArray *weekdayNames = [NSArray arrayWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT", nil];
    NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
    NSUInteger i = firstWeekday - 1;
    for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
        CGRect weekdayFrame = CGRectMake(xOffset, 0.0f, 46.f, 20.0f);
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
        weekdayLabel.backgroundColor = [UIColor clearColor];
        weekdayLabel.font = [UIFont boldSystemFontOfSize:10.f];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.f];
        weekdayLabel.text = [weekdayNames objectAtIndex:i];
        [headerView addSubview:weekdayLabel];
        [weekdayLabel release];

        [headerView setBackgroundColor:[UIColor colorWithRed:40/255.0f green:185/255.0f blue:125/255.0f alpha:1.0f]];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

    gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self];
    [gridView setMultipleTouchEnabled:YES];
    [gridView setUserInteractionEnabled:YES];
    [contentView addSubview:gridView];
    [gridView sizeToFit];
        
    weekGridView = [[KalWeekGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self];
    [weekGridView setMultipleTouchEnabled:YES];
    [weekGridView setUserInteractionEnabled:YES];
    [contentView addSubview:weekGridView];
    [weekGridView sizeToFit];
    
    /*
    eventView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    CalendarIntegrationView *listView = [CalendarIntegrationView createCalendarIntegrationView];
    [contentView addSubview:eventView];
    [eventView addSubview:listView];
    [eventView setContentSize:listView.frame.size];
    [eventView setScrollEnabled:YES];
    [eventView setShowsHorizontalScrollIndicator:YES];
    [eventView setBounces:NO];
    [eventView setHidden:YES];
     */
    
    [self setFrameToWeekMode];
    KalMode = WEEK_MODE;

  
//    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}


 
-(void)addPanGestureRecognizer
{
    UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)] autorelease];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
    [panGesture requireGestureRecognizerToFail:gridView.oneFingerSwipeRight];
    [panGesture requireGestureRecognizerToFail:gridView.oneFingerSwipeLeft];
    [panGesture requireGestureRecognizerToFail:weekGridView.oneFingerSwipeLeft];
    [panGesture requireGestureRecognizerToFail:weekGridView.oneFingerSwipeRight];
}

- (void)hideViewWithAlphaAnimation:(UIView *)view
{
    CGFloat animationDuring = 0.2f;
    [UIView animateWithDuration:animationDuring animations:^{
        view.alpha = 0.0f;
    } completion:^(BOOL finished){
        [view setHidden:YES];
        view.alpha = 1.0f;
    }];
}

- (void)showViewWithAlphaAnimation:(UIView *)view
{
    CGFloat animationDuring = 0.2f;
    view.alpha = 0.0f;
    [view setHidden:NO];
    [UIView animateWithDuration:animationDuring animations:^{
        view.alpha = 1.0f;
    } completion:^(BOOL finished){
    }];
}

- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.superview];
    CGFloat animationDuring = 0.2f;
    
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
}


 /* swip gesture， hang-up temporary
-(void)addUISwipGestureRecognizer{
    UISwipeGestureRecognizer *oneFingerSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)] autorelease];
    [oneFingerSwipeDown setDelegate:self];
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:oneFingerSwipeDown];
    
    UISwipeGestureRecognizer *oneFingerSwipUP = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipUP:)] autorelease];
    [oneFingerSwipUP setDelegate:self];
    [oneFingerSwipUP setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:oneFingerSwipUP];
}

- (void)oneFingerSwipUP:(UISwipeGestureRecognizer *)recognizer
{
    if (KalMode == WEEK_MODE) {
        KalMode = MONTH_MODE;
        [gridView removeObserver:self forKeyPath:@"frame"];
        [gridView jumpToSelectedMonth];
        [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrameToMonthMode];
            [weekGridView setFrame:CGRectMake(0 , gridView.height + headerView.height, self.frame.size.width, weekGridView.height)];
            
        } completion:^(BOOL finished){
            [weekGridView setHidden:YES];
        }];
    }
    else
    {
        KalMode = LIST_MODE;
        
        int y = gridView.frame.origin.y + gridView.frame.size.height;
        int h = [self screenHeight] - 75 - 20 -y;
        
        [eventView setFrame:CGRectMake(0 , y, self.frame.size.width, h)];
        [eventView setHidden:NO];
        [delegate monthModeToEventMode];
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrameToListMode];
        } completion:^(BOOL finished){
            gridView.enableMonthChange = NO;
        }];
    }
}

- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    if (KalMode == MONTH_MODE) {
        KalMode = WEEK_MODE;
        [weekGridView jumpToSelectedWeek];
        
        [weekGridView setHidden:NO];
        [weekGridView setFrame:CGRectMake(0 ,gridView.height, self.frame.size.width, weekGridView.height)];
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrameToWeekMode];
            [weekGridView setFrame:CGRectMake(0 ,0, self.frame.size.width, weekGridView.height)];
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        KalMode = MONTH_MODE;
        [delegate eventModeToMontMode];
        [UIView animateWithDuration:0.5 animations:^{
            [self setFrameToMonthMode];
        } completion:^(BOOL finished){
            [eventView setHidden:YES];
            gridView.enableMonthChange = YES;
        }];
    }
}
*/

- (float)screenHeight
{
    CGFloat statusBarHeight = 0.0f;
    if (![UIApplication sharedApplication].statusBarHidden)
    {
        statusBarHeight = 20.0f;
    }
    return [[UIScreen mainScreen] bounds].size.height - statusBarHeight;
}

- (void)setFrameToWeekMode
{
    [self setFrame:CGRectMake(0, [self screenHeight] - weekGridView.height - headerView.height, self.frame.size.width, weekGridView.height + headerView.frame.size.height)];
}

- (void)setFrameToMonthMode
{
    [self setFrame:CGRectMake(0, [self screenHeight] - gridView.height - headerView.height, self.frame.size.width, gridView.height + headerView.frame.size.height)];
}

- (void)setFrameToListMode
{
    [self setFrame:CGRectMake(0, 75, self.frame.size.width, gridView.height + headerView.frame.size.height + eventView.frame.size.height)];
}



#pragma mark -
#pragma mark recall
- (void)didSelectDate:(KalDate *)date
{
    NSLog(@"didSelectDate: year:%d,month:%d,day:%d",date.year,date.month,date.day);
    [self.delegate didSelectDate:date];
}

- (void)showListView
{
    [self.delegate showListView];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [UIView animateWithDuration:0.5 animations:^{
      [self setFrameToMonthMode];
    }
    completion:nil];
}

- (void)jumpToSelectedMonth
{
    [gridView jumpToSelectedMonth];
}

- (void)dealloc
{
    [logic release];

    [headerTitleLabel release];
    [gridView removeObserver:self forKeyPath:@"frame"];
    [gridView release];

    [weekGridView release];

    [super dealloc];
}

-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource
{
    [self setKalTileViewDataSource:datasource andView:gridView.frontMonthView];
    [self setKalTileViewDataSource:datasource andView:weekGridView.frontWeekView];
    [self setKalTileViewDataSource:datasource andView:gridView.backMonthView];
    [self setKalTileViewDataSource:datasource andView:weekGridView.backWeekView];
}

-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource andView:(UIView *) view
{
    NSArray * subViews = [view subviews];
    
    for(int i=0; i<subViews.count; i++) {
        UIView * subView = [subViews objectAtIndex:i];
        
        if( [subView isKindOfClass:[KalTileView class]]) {
            KalTileView * tileView = (KalTileView *) subView;
            tileView.datasource = datasource;
        }
    }
}

-(void) setNeedsDisplay
{
    [super setNeedsDisplay];

    [self setNeedsDisplay:gridView.frontMonthView];
    [self setNeedsDisplay:weekGridView.frontWeekView];
    [self setNeedsDisplay:gridView.frontMonthView];
    [self setNeedsDisplay:weekGridView.backWeekView];
}

-(void) setNeedsDisplay:(UIView *) view
{
    NSArray * subViews = [view subviews];

    for(int i=0; i<subViews.count; i++) {
        UIView * subView = [subViews objectAtIndex:i];

        if( [subView isKindOfClass:[KalTileView class]]) {
            [subView setNeedsDisplay];
        }
    }
}

@end
