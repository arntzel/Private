#import "KalWeekView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

extern const CGSize kTileSize;

@implementation KalWeekView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.clipsToBounds = YES;
        for (int j=0; j<7; j++) {
            CGRect r = CGRectMake(j*kTileSize.width, 0, kTileSize.width, kTileSize.height);
            [self addSubview:[[[KalTileView alloc] initWithFrame:r] autorelease]];
        }
    }
    return self;
}

- (void)showDates:(NSArray *)mainDates selectedDate:(KalDate *)_selectedDate
{    
    for (int tileNum = 0; tileNum < 7; tileNum++) {
        KalDate *d = [mainDates objectAtIndex:tileNum];
        KalTileView *tile = [self.subviews objectAtIndex:tileNum];
        [tile resetState];
        tile.date = d;
        tile.type = [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
        if ([tile.date isEqual:_selectedDate]) {
            tile.selected = YES;
        }
    }
    
    [self sizeToFit];
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
    
    [self setNeedsDisplay];
}

- (void)sizeToFit
{
    self.height = 1.f + kTileSize.height;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        NSLog(@"%@",t.date);
        if ([t.date isEqual:date])
        {
            tile = t;
            break;
        }
    }
    NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
    
    return tile;
}

@end
