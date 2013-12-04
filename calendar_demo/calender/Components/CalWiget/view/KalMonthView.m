
#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalMonthView
@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.clipsToBounds = YES;
        
        
        for (int i=0; i<6; i++)
        {
            for (int j=0; j<7; j++)
            {
                CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
                [self addSubview:[[[KalTileView alloc] initWithFrame:r] autorelease]];
            }
        }
    }
    return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates selectedDate:(KalDate *)_selectedDate
{
    int tileNum = 0;
    NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };

    for (int i=0; i<3; i++) {
        for (KalDate *d in dates[i])
        {
            KalTileView *tile = [self.subviews objectAtIndex:tileNum];
            [tile resetState];
            tile.date = d;
            tile.type = dates[i] != mainDates ? KalTileTypeAdjacent: KalTileTypeRegular;
            if ([tile.date isEqual:_selectedDate] && (tile.type == KalTileTypeRegular))
            {
                tile.selected = YES;
            }
            tileNum++;
        }
    }

    numWeeks = ceilf(tileNum / 7.f);
    [self sizeToFit];
    [self setNeedsDisplay];
}

-(void) setSelectedDate:(KalDate *)_selectedDate
{
    for (UIView *view in [self subviews]) {
        
        if([view isKindOfClass:[KalTileView class]]) {
            
            KalTileView * tileView = (KalTileView *)view;
            
            if ([tileView.date isEqual:_selectedDate]) {
                tileView.selected = YES;
            } else {
                tileView.selected = NO;
            }
        }
    }
    
    [self setNeedsDisplay];
}

- (void)clearSelectedState
{
    for (UIView *view in [self subviews]) {
        if([view isKindOfClass:[KalTileView class]]) {
            KalTileView * tileView = (KalTileView *)view;
            if (tileView.selected == YES)
                tileView.selected = NO;
        }
    }
    
    [self setNeedsDisplay];
}

- (KalTileView *)tileForDate:(KalDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        if ([t.date isEqual:date]) {
            tile = t;
            break;
        }
    }
    NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);

    return tile;
}

- (void)sizeToFit
{
    self.height = 1.f + kTileSize.height * numWeeks;
}

@end
