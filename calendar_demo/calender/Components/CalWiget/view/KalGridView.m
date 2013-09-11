#import <CoreGraphics/CoreGraphics.h>

#import "KalGridView.h"
#import "KalView.h"
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalLogic.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "KalMonthNameView.h"

#define SLIDE_NONE 0
#define SLIDE_LEFT 1
#define SLIDE_RIGHT 2

extern const CGSize kTileSize;

@interface KalGridView ()<UIGestureRecognizerDelegate>
{    

    KalMonthNameView *monthNameView;
}
- (void)swapMonthViews;
@end

@implementation KalGridView
@synthesize frontMonthView, backMonthView;
@synthesize enableMonthChange;
@synthesize oneFingerSwipeLeft;
@synthesize oneFingerSwipeRight;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalGridViewDelegate>)theDelegate
{
    frame.size.width = 7 * kTileSize.width;
    
  
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setBackgroundColor:[UIColor clearColor]];
        
        enableMonthChange = YES;
        logic = [theLogic retain];
        delegate = theDelegate;
      
        CGRect monthRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        backMonthView = [[KalMonthView alloc] initWithFrame:monthRect];
        [self addSubview:backMonthView];
        [self addSubview:frontMonthView];

        [self jumpToSelectedMonth];
        [self addUISwipGestureRecognizer:self];
        
        monthNameView = [[KalMonthNameView alloc] initWithFrame:CGRectZero];
        [self addSubview:monthNameView];
    }
  
    return self;
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
    if (enableMonthChange) {
        [self slideLeft];
    }
}

- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    if (enableMonthChange) {
        [self slideRight];
    }
}

- (void)sizeToFit
{
    self.height = frontMonthView.height;
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
        
        if (tile.belongsToAdjacentMonth && (!enableMonthChange)) {
            return;
        }
        if (![[logic selectedDay] isEqual:tile.date]) {
            [logic setSelectedDay:tile.date];
            [delegate didSelectDate:tile.date];
            
            [frontMonthView clearSelectedState];
            [backMonthView clearSelectedState];
            tile.selected = YES;
        }
        
        if (tile.belongsToAdjacentMonth)
        {
            if ([tile.date compare:logic.showMonth] == NSOrderedDescending)
            {
                [self slideLeft];
            }
            else
            {
                [self slideRight];
            }
        }

    }
}

#pragma mark -
#pragma mark Slide Animation
- (void)jumpToSelectedMonth
{
    [logic ajustShowMonth];
    [self slide:SLIDE_NONE];
}

- (void)slideLeft
{
    [logic advanceToFollowingMonth];
    [delegate willShowMonth:logic.showMonth];
    [self slide:SLIDE_LEFT];
}

- (void)slideRight
{
    [logic retreatToPreviousMonth];
    [delegate willShowMonth:logic.showMonth];
    [self slide:SLIDE_RIGHT];
}

- (void)slide:(int)direction
{
    [backMonthView showDates:[logic daysInShowingMonth]
    leadingAdjacentDates:[logic daysInFinalWeekOfPreviousMonth]
    trailingAdjacentDates:[logic daysInFirstWeekOfFollowingMonth] selectedDate:[logic selectedDay]];
    
    [self swapMonthsAndSlide:direction];
}

- (void)swapMonthsAndSlide:(int)direction
{
    if (direction == SLIDE_LEFT) {
        backMonthView.left = frontMonthView.width;
    }
    else if (direction == SLIDE_RIGHT)
    {
        backMonthView.left = -frontMonthView.width;
    }
    else
    {//no animation
        backMonthView.left = 0;
        frontMonthView.left = -frontMonthView.width;
        self.height = backMonthView.height;
        [self swapMonthViews];
        return;
    }
    
    [monthNameView setFrame:frontMonthView.frame];
    [monthNameView setMonthNameAtIndex:[logic.showMonth month]];
    [monthNameView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (direction == SLIDE_LEFT) {
            frontMonthView.left = -frontMonthView.width;
        }
        else
        {
            frontMonthView.left = frontMonthView.width;
        }
        backMonthView.left = 0;
        self.height = backMonthView.height;
        
        [monthNameView setFrame:backMonthView.frame];
    } completion:^(BOOL finished) {
        [self swapMonthViews];
    }];
    
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [monthNameView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
            [monthNameView setAlpha:0.0f];
        } completion:nil];
    }];
}

- (void)swapMonthViews
{
    KalMonthView *tmp = backMonthView;
    backMonthView = frontMonthView;
    frontMonthView = tmp;
    [self exchangeSubviewAtIndex:[self.subviews indexOfObject:frontMonthView] withSubviewAtIndex:[self.subviews indexOfObject:backMonthView]];
}

#pragma mark -

- (void)dealloc
{
    [frontMonthView release];
    [backMonthView release];
    [logic release];
    [monthNameView release];

    [super dealloc];
}

@end