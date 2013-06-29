/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

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
    
    UISwipeGestureRecognizer *oneFingerSwipeDown;
    UISwipeGestureRecognizer *oneFingerSwipUP;
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
    
    KalDate *selectedDate;
}

- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView;
- (void)setHeaderTitleText:(NSString *)text;
@end

extern const CGSize kTileSize;
//static const CGFloat kHeaderHeight = 44.f;
static const CGFloat kHeaderHeight = 20.0f;
static const CGFloat kMonthLabelHeight = 17.f;

@implementation KalView
@synthesize selectedDate;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic selectedDate:(KalDate *)_selectedDate
{
  if ((self = [super initWithFrame:frame])) {
      self.selectedDate = _selectedDate;
    delegate = theDelegate;
    logic = [theLogic retain];
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    
    headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
    headerView.backgroundColor = [UIColor grayColor];
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
    
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubviewsToContentView:contentView];
    [self addSubview:contentView];
      
    _contentView = contentView;
      
    [self addUISwipGestureRecognizer:self];
  }
  
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideLeft
{
    if (KalMode == WEEK_MODE)
    {
        [weekGridView slideLeft];
    }
    else if(KalMode == MONTH_MODE)
    {
        [gridView slideLeft];
    }
}

- (void)slideRight
{
    if (KalMode == WEEK_MODE) {
        [weekGridView slideRight];
    }
    else if(KalMode == MONTH_MODE)
    {
        [gridView slideRight];
    }
}

- (void)addSubviewsToHeaderView:(UIView *)_headerView
{

    NSArray *weekdayNames = [NSArray arrayWithObjects:@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT", nil];
  NSUInteger firstWeekday = [[NSCalendar currentCalendar] firstWeekday];
  NSUInteger i = firstWeekday - 1;
  for (CGFloat xOffset = 0.f; xOffset < headerView.width; xOffset += 46.f, i = (i+1)%7) {
    CGRect weekdayFrame = CGRectMake(xOffset, 0.0f, 46.f, 20.0f);
//      CGRect weekdayFrame = CGRectMake(xOffset, 30.f, 46.f, kHeaderHeight - 29.f);

    UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:weekdayFrame];
    weekdayLabel.backgroundColor = [UIColor clearColor];
    weekdayLabel.font = [UIFont boldSystemFontOfSize:10.f];
    weekdayLabel.textAlignment = NSTextAlignmentCenter;
//    weekdayLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.f];
      weekdayLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.f];
//    weekdayLabel.shadowColor = [UIColor whiteColor];
//    weekdayLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    weekdayLabel.text = [weekdayNames objectAtIndex:i];
    [headerView addSubview:weekdayLabel];
    [weekdayLabel release];
      
      [headerView setBackgroundColor:[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1.0f]];
  }
}

- (void)addSubviewsToContentView:(UIView *)contentView
{
  // Both the tile grid and the list of events will automatically lay themselves
  // out to fit the # of weeks in the currently displayed month.
  // So the only part of the frame that we need to specify is the width.
  CGRect fullWidthAutomaticLayoutFrame = CGRectMake(0.f, 0.f, self.width, 0.f);

  // The tile grid (the calendar body)
  gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self];
    [gridView setMultipleTouchEnabled:YES];
    [gridView setUserInteractionEnabled:YES];
  [contentView addSubview:gridView];
        
    weekGridView = [[KalWeekGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:self];
    [weekGridView setMultipleTouchEnabled:YES];
    [weekGridView setUserInteractionEnabled:YES];
    [contentView addSubview:weekGridView];
    
    
    eventView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    CalendarIntegrationView *listView = [CalendarIntegrationView createCalendarIntegrationView];
    [contentView addSubview:eventView];
    [eventView addSubview:listView];
    [eventView setContentSize:listView.frame.size];
    [eventView setScrollEnabled:YES];
    [eventView setShowsHorizontalScrollIndicator:YES];
    [eventView setBounces:NO];
    [eventView setHidden:YES];
    
    [self setFrameToWeekMode];
    KalMode = WEEK_MODE;
  
  // Trigger the initial KVO update to finish the contentView layout
    [gridView sizeToFit];
    [weekGridView sizeToFit];
    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [weekGridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)addUISwipGestureRecognizer:(UIView *)view {
    oneFingerSwipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)] autorelease];
    [oneFingerSwipeDown setDelegate:self];
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:oneFingerSwipeDown];
    
    oneFingerSwipUP = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipUP:)] autorelease];
    [oneFingerSwipUP setDelegate:self];
    [oneFingerSwipUP setDirection:UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:oneFingerSwipUP];
}

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
            NSLog(@"headerView.height : %f",headerView.height);
            
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
        }];
    }
}




#pragma mark -
#pragma mark recall
- (void)showPreviousMonth
{
    if (!gridView.transitioning)
    {
        [logic retreatToPreviousMonth];
        [self slideRight];
    }
}

- (void)showFollowingMonth
{
    if (!gridView.transitioning)
    {
        [logic advanceToFollowingMonth];
        [self slideLeft];
    }
}

- (void)showPreviousWeek
{
    if (!gridView.transitioning)
    {
        [logic retreatToPreviousWeek];
        [self slideRight];
    }
}

- (void)showFollowingWeek
{
    if (!gridView.transitioning)
    {
        [logic advanceToFollowingWeek];
        [self slideLeft];
    }
}

- (void)didSelectDate:(KalDate *)date
{
    self.selectedDate = date;
    [self.delegate didSelectDate:date];
}

- (void)showListView
{
    [self.delegate showListView];
}

- (KalDate *)selectedDate
{
    return selectedDate;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    
    /* Animate tableView filling the remaining space after the
     * gridView expanded or contracted to fit the # of weeks
     * for the month that is being displayed.
     *
     * This observer method will be called when gridView's height
     * changes, which we know to occur inside a Core Animation
     * transaction. Hence, when I set the "frame" property on
     * tableView here, I do not need to wrap it in a
     * [UIView beginAnimations:context:].
     */
    CGFloat gridBottom = gridView.top + gridView.height;
    shadowView.top = gridBottom;
    
      [UIView animateWithDuration:0.5 animations:^{
          [self setFrameToMonthMode];
      } completion:^(BOOL finished){
      }];
  }
  else if(object == weekGridView && [keyPath isEqualToString:@"frame"])
  {
      CGFloat gridBottom = weekGridView.top + weekGridView.height;
      shadowView.top = gridBottom;
  }
  else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
  [headerTitleLabel sizeToFit];
  headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (void)dealloc
{
    self.selectedDate = nil;
    
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
    
    [weekGridView removeObserver:self forKeyPath:@"frame"];
    [weekGridView release];
    
  [shadowView release];
  [super dealloc];
}

-(void) setKalTileViewDataSource:(NSObject<KalTileViewDataSource> *) datasource
{
    KalMonthView * monthView = gridView.frontMonthView;
    [self setKalTileViewDataSource:datasource andView:monthView];
    [self setKalTileViewDataSource:datasource andView:weekGridView];
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
@end
