//
//  KalWeekGridView.m
//  calTest
//
//  Created by zyax86 on 13-5-12.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

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
    UISwipeGestureRecognizer *oneFingerSwipeDown;
    UISwipeGestureRecognizer *oneFingerSwipUP;
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft;
    UISwipeGestureRecognizer *oneFingerSwipeRight;
}
@property (nonatomic, retain) KalTileView *selectedTile;
@property (nonatomic, retain) KalTileView *highlightedTile;
- (void)swapWeekViews;
@end

extern const CGSize kTileSize;
static NSString *kWeekSlideAnimationId = @"KalSwitchWeeks";

@implementation KalWeekGridView
@synthesize selectedTile, highlightedTile, transitioning;

- (id)initWithFrame:(CGRect)frame logic:(KalLogic *)theLogic delegate:(id<KalWeekGridViewDelegate>)theDelegate
{
    frame.size.width = 7 * kTileSize.width;
    
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        logic = [theLogic retain];
        delegate = theDelegate;
        
        CGRect weekRect = CGRectMake(0.f, 0.f, frame.size.width, frame.size.height);
        frontWeekView = [[KalWeekView alloc] initWithFrame:weekRect];
        backWeekView = [[KalWeekView alloc] initWithFrame:weekRect];
        backWeekView.hidden = YES;
        [self addSubview:frontWeekView];
        [self addSubview:backWeekView];
        
        [self jumpToSelectedWeek];
        
        [self addUISwipGestureRecognizer:self];
    }
    return self;
}

- (void)jumpToSelectedWeek
{
    [self slide:SLIDE_NONE];
}

#pragma mark -
#pragma mark Slide Actions

- (void)slideLeft
{
    [self slide:SLIDE_LEFT];
}

- (void)slideRight
{
    [self slide:SLIDE_RIGHT];
}

- (void)slide:(int)direction
{
    transitioning = YES;
    
    [logic moveToWeekForDate:logic.weekBaseDate];
    [backWeekView showDates:logic.daysInSelectedWeek selectedDate:[delegate selectedDate]];
    
    [self swapMonthsAndSlide:direction];
}

- (void)swapMonthsAndSlide:(int)direction
{
    backWeekView.hidden = NO;
    
    if (direction == SLIDE_LEFT) {
        backWeekView.left = frontWeekView.width;
    }
    else
    {
        backWeekView.left = -frontWeekView.width;
    }
    
    // trigger the slide animation
    [UIView beginAnimations:kWeekSlideAnimationId context:NULL]; {
        [UIView setAnimationsEnabled:direction!=SLIDE_NONE];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        if (direction == SLIDE_LEFT) {
            frontWeekView.left = -frontWeekView.width;
        }
        else
        {
            frontWeekView.left = frontWeekView.width;
        }
        backWeekView.left = 0;
        
        self.height = backWeekView.height;
        
        [self swapWeekViews];
    } [UIView commitAnimations];
    [UIView setAnimationsEnabled:YES];
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
    [delegate showFollowingWeek];
}

- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [delegate showPreviousWeek];
}


- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"Kal.bundle/kal_grid_background.png"] drawInRect:rect];
    [[UIColor colorWithRed:0.63f green:0.65f blue:0.68f alpha:1.f] setFill];
    CGRect line;
    line.origin = CGPointMake(0.f, self.height - 1.f);
    line.size = CGSizeMake(self.width, 1.f);
    CGContextFillRect(UIGraphicsGetCurrentContext(), line);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark Touches

- (void)setHighlightedTile:(KalTileView *)tile
{
    if (highlightedTile != tile) {
        highlightedTile.highlighted = NO;
        highlightedTile = [tile retain];
        tile.highlighted = YES;
        [tile setNeedsDisplay];
    }
}

- (void)setSelectedTile:(KalTileView *)tile
{
    if (selectedTile != tile) {
        selectedTile.selected = NO;
        selectedTile = [tile retain];
        tile.selected = YES;
        [delegate didSelectDate:tile.date];
    }
}


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
        self.selectedTile = tile;
    }
    self.highlightedTile = nil;
}


- (void)selectDate:(KalDate *)date
{
    self.selectedTile = [frontWeekView tileForDate:date];
}

- (KalDate *)selectedDate
{
    return [delegate selectedDate];
}

- (void)markTilesForDates:(NSArray *)dates
{
    [frontWeekView markTilesForDates:dates];
}

- (void)sizeToFit
{
    self.height = frontWeekView.height;
}

#pragma mark -

- (void)dealloc
{
    [selectedTile release];
    [highlightedTile release];
    [frontWeekView release];
    [backWeekView release];
    [logic release];
    [super dealloc];
}

@end
