//
//  KalWeekView.m
//  calTest
//
//  Created by zyax86 on 13-5-12.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

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
        self.opaque = NO;
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

- (void)sizeToFit
{
    self.height = 1.f + kTileSize.height;
}

- (KalTileView *)firstTileOfWeek
{
    KalTileView *tile = nil;
    for (KalTileView *t in self.subviews) {
        tile = t;
        break;
    }
    
    return tile;
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

- (void)markTilesForDates:(NSArray *)dates
{
    for (KalTileView *tile in self.subviews)
        tile.marked = [dates containsObject:tile.date];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
//}

@end
