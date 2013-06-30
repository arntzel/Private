#import "KalWeekGridView.h"

#import "KalGridView.h"
#import "KalView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define SLIDE_NONE 0
#define SLIDE_LEFT 1
#define SLIDE_RIGHT 2

@interface KalWeekGridView()<UIGestureRecognizerDelegate>
{    
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
}
@end

extern const CGSize kTileSize;

@implementation KalWeekGridView
@synthesize frontWeekView,backWeekView;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalWeekGridViewDelegate>)theDelegate
{
    frame.size.width = 7 * kTileSize.width;
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        logic = [theLogic retain];
        delegate = theDelegate;
        
        CGRect weekRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontWeekView = [[KalWeekView alloc] initWithFrame:weekRect];
        backWeekView = [[KalWeekView alloc] initWithFrame:weekRect];
        [self addSubview:frontWeekView];
        [self addSubview:backWeekView];
        
        [self jumpToSelectedWeek];
        
        [self addUISwipGestureRecognizer:self];
    }
    return self;
}

#pragma mark -
#pragma mark Slide Actions

- (void)jumpToSelectedWeek
{
    [logic ajustShowWeek];
    [self slide:SLIDE_NONE];
}

- (void)slideLeft
{
    [logic advanceToFollowingWeek];
    [self slide:SLIDE_LEFT];
}

- (void)slideRight
{
    [logic retreatToPreviousWeek];
    [self slide:SLIDE_RIGHT];
}

- (void)slide:(int)direction
{
    [backWeekView showDates:[logic daysInShowingWeek] selectedDate:[logic selectedDay]];
    [self swapMonthsAndSlide:direction];
}

- (void)swapMonthsAndSlide:(int)direction
{    
    if (direction == SLIDE_LEFT) {
        backWeekView.left = frontWeekView.width;
    }
    else if (direction == SLIDE_RIGHT)
    {
        backWeekView.left = -frontWeekView.width;
    }
    else
    {
        //no animation
        frontWeekView.left = frontWeekView.width;
        backWeekView.left = 0;
        self.height = backWeekView.height;
        [self swapWeekViews];
        return;
    }
    
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         if (direction == SLIDE_LEFT) {
             frontWeekView.left = -frontWeekView.width;
         }
         else
         {
             frontWeekView.left = frontWeekView.width;
         }
         backWeekView.left = 0;
         
         self.height = backWeekView.height;
     } completion:^(BOOL finished) {
         [self swapWeekViews];
     }];
}

- (void)swapWeekViews
{
    KalWeekView *tmp = backWeekView;
    backWeekView = frontWeekView;
    frontWeekView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontWeekView] withSubviewAtIndex:[self.subviews indexOfObject:backWeekView]];
}


-(void)addUISwipGestureRecognizer:(UIView *)view {
    
    oneFingerSwipeLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)] autorelease];
    [oneFingerSwipeLeft setDelegate:self];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:oneFingerSwipeLeft];
    
    oneFingerSwipeRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeRight:)] autorelease];
    [oneFingerSwipeRight setDelegate:self];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:oneFingerSwipeRight];
}

- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self slideLeft];
}

- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self slideRight];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *hitView = [self hitTest:location withEvent:event];
    
    if ([hitView isKindOfClass:[KalTileView class]]) {
        KalTileView *tile = (KalTileView*)hitView;
        
        if (![[logic selectedDay] isEqual:tile.date]) {
            [logic setSelectedDay:tile.date];
            [delegate didSelectDate:tile.date];
            
            [frontWeekView clearSelectedState];
            [backWeekView clearSelectedState];
            tile.selected = YES;
        }
    }
}

- (void)sizeToFit
{
    self.height = frontWeekView.height;
}

#pragma mark -

- (void)dealloc
{
    [frontWeekView release];
    [backWeekView release];
    [logic release];
    [super dealloc];
}

@end
