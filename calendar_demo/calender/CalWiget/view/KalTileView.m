/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import <QuartzCore/QuartzCore.h>

const CGSize kTileSize = { 46.f, 44.f };
@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];


    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ref=UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, 0,0);
    CGContextAddLineToPoint(ref, self.frame.size.width,0);
    CGFloat lineColor1[4]={1.0,1.0,1.0,1.0};
    CGContextSetStrokeColor(ref, lineColor1);
    CGContextStrokePath(ref);
    
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, 0,1);
    CGContextAddLineToPoint(ref, self.frame.size.width,1);
    CGFloat lineColor2[4]={210/255.0,210/255.0,210/255.0,1.0};
    CGContextSetStrokeColor(ref, lineColor2);
    CGContextStrokePath(ref);
    
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, self.frame.size.width - 1,0);
    CGContextAddLineToPoint(ref, self.frame.size.width - 1,self.frame.size.height);
    CGFloat lineColor3[4]={242/255.0,242/255.0,242/255.0,1.0};
    CGContextSetStrokeColor(ref, lineColor3);
    CGContextStrokePath(ref);
    
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, self.frame.size.width - 2,1);
    CGContextAddLineToPoint(ref, self.frame.size.width - 2,self.frame.size.height);
    CGFloat lineColor4[4]={210/255.0,210/255.0,210/255.0,1.0};
    CGContextSetStrokeColor(ref, lineColor4);
    CGContextStrokePath(ref);
    
        
    
    
    
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 15.f;
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *textColor = nil;
    if (self.selected) {
        textColor = [UIColor whiteColor];
    }
    else if(self.belongsToAdjacentMonth)
    {
        textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    }
    else
    {
        textColor = [UIColor colorWithRed:140.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    }
    
    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGContextTranslateCTM(ctx, 0, kTileSize.height);
    CGContextScaleCTM(ctx, 1, -1);
    
  
    //draw day
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
    
    CGFloat radio = 0.0f;
    if (n < 10) {
        radio = 0.5f;
    }
    else
    {
        radio = 0.4f;
    }
  textX = roundf(0.5f * (kTileSize.width - textSize.width)) - 2;
  textY = roundf(0.5f * (kTileSize.height - textSize.height)) + 2;

    
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);

    //draw month
    if (n == 1) {
        NSArray *monthArray = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"April",@"May",@"Jun",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        NSString *monthName = [monthArray objectAtIndex:date.month - 1];
        
        
        
        const char *cMonthName = [monthName cStringUsingEncoding:NSUTF8StringEncoding];
        CGSize textSize = [monthName sizeWithFont:font];
        CGFloat textX, textY;

        textX = roundf(0.5f * (kTileSize.width - textSize.width)) - 2;
        textY = roundf(0.5f * (kTileSize.height - textSize.height)) + 16;
        
        
        [textColor setFill];
        CGContextShowTextAtPoint(ctx, textX, textY, cMonthName, [monthName length]);
    }
    

}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end
