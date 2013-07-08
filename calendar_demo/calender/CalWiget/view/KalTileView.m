#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

const CGSize kTileSize = { 46.f, 44.f };
@implementation KalTileView

@synthesize date, datasource;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
      
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    UIColor *textColor = nil;

    if (self.selected || [date isToday]) {
        textColor = [UIColor whiteColor];

        if(self.selected) {
            CGContextSetRGBFillColor(ctx, 90.0/255.0f, 90.0/255.0f, 90.0/255.0f, 1);
        } else {
            CGContextSetRGBFillColor(ctx, 150/255.0f, 150/255.0f, 150/255.0f, 1);
        }
        
        CGContextSetLineWidth(ctx, 1.0f);
        CGContextAddRect(ctx, CGRectMake(0, 0, kTileSize.width, kTileSize.height));
        CGContextFillPath(ctx);
        
    } 
    else if(self.belongsToAdjacentMonth)
    {
        textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    }
    else
    {
        textColor = [UIColor colorWithRed:140.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    }
    
    
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0,0);
    CGContextAddLineToPoint(ctx, self.frame.size.width,0);
    CGFloat lineColor1[4]={1.0,1.0,1.0,1.0};
    CGContextSetStrokeColor(ctx, lineColor1);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0,1);
    CGContextAddLineToPoint(ctx, self.frame.size.width,1);
    CGFloat lineColor2[4]={210/255.0,210/255.0,210/255.0,1.0};
    CGContextSetStrokeColor(ctx, lineColor2);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.frame.size.width - 1,0);
    CGContextAddLineToPoint(ctx, self.frame.size.width - 1,self.frame.size.height);
    CGFloat lineColor3[4]={242/255.0,242/255.0,242/255.0,1.0};
    CGContextSetStrokeColor(ctx, lineColor3);
    CGContextStrokePath(ctx);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.frame.size.width - 2,1);
    CGContextAddLineToPoint(ctx, self.frame.size.width - 2,self.frame.size.height);
    CGFloat lineColor4[4]={210/255.0,210/255.0,210/255.0,1.0};
    CGContextSetStrokeColor(ctx, lineColor4);
    CGContextStrokePath(ctx);
    
        
    
    
    
//  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 17.f;
  UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGContextTranslateCTM(ctx, 0, kTileSize.height);
    CGContextScaleCTM(ctx, 1, -1);
    
  
    //draw day
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
    
  textX = roundf(0.5f * (kTileSize.width - textSize.width)) - 1;
//  textY = roundf(0.5f * (kTileSize.height - textSize.height)) + 2;
    if (n == 1) {
        textY = 14.0f;
    }
    else
    {
        textY = 17.0f;
    }
  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);

    //draw month
    if (n == 1) {
        fontSize = 10.0f;
        UIFont *monthFont = [UIFont boldSystemFontOfSize:fontSize];
        
        CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
        CGContextTranslateCTM(ctx, 0, 0);
        NSArray *monthArray = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"April",@"May",@"Jun",@"July",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
        NSString *monthName = [monthArray objectAtIndex:date.month - 1];
        const char *cMonthName = [monthName cStringUsingEncoding:NSUTF8StringEncoding];
        textSize = [monthName sizeWithFont:monthFont];
        
        textX = roundf(0.5f * (kTileSize.width - textSize.width)) - 1;
        textY = 30;
        
        [textColor setFill];
        CGContextShowTextAtPoint(ctx, textX, textY, cMonthName, [monthName length]);
    }
    
    if(self.datasource == nil) return;
    
    //draw event color dot
    int eventType = [self.datasource getEventType:self.date];
    
    BOOL google = eventType & 0x00000002;
    BOOL fackbook = eventType & 0x00000008;
    //BOOL birthday = eventType & 0x00000010;
    
    int count = 0;
    if(google) count++;
    if(fackbook) count++;
    //if(birthday) count++;
    
    if (count == 0) {
        return;
    }
    
    CGFloat dotLength = 10 * count - 5;
    CGFloat OffsetX = (kTileSize.width - dotLength) * 0.5f - 1;
    
    CGFloat OffsetY = 8.0f;
    if (n == 1) {
        OffsetY = 5.0f;
    }
    
    CGPoint position;
    position.x = OffsetX;
    position.y = OffsetY;
    
    
    if(google) {
        [self drawColordot:ctx andPosition:position andColor:0xFFFF0000];
        position.x += 10.0f;
    }
    
    if(fackbook) {
        [self drawColordot:ctx andPosition:position andColor:0xFF00FF00];
        position.x += 10.0f;
    }

    /*
    if(birthday) {
        [self drawColordot:ctx andPosition:position andColor:0xFF0000FF];
        position.x += 10.0f;
    }
     */
}

-(void) drawColordot:(CGContextRef)ctx andPosition:(CGPoint) position andColor:(int) color
{
    CGContextSetRGBFillColor(ctx, COLOR_R(color), COLOR_G(color), COLOR_B(color), COLOR_A(color)/255.0f);
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextAddEllipseInRect(ctx, CGRectMake(position.x, position.y, 5, 5));
    CGContextFillPath(ctx);
}

- (void)resetState
{
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
  self.date = nil;
  self.datasource = nil;
    
  [super dealloc];
}

@end
