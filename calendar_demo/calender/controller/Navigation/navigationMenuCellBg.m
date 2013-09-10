
#import "navigationMenuCellBg.h"

@implementation navigationMenuCellBg

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGFloat lineColor1[4]={60.0/255.0f,65.0/255.0f,70.0/255.0f,1.0};
    CGContextSetStrokeColor(ctx, lineColor1);
    CGContextSetLineWidth(ctx, 2.0f);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 3,0.0f);
    CGContextAddLineToPoint(ctx, self.frame.size.width,0.0f);
    CGContextStrokePath(ctx);
    
    
    CGFloat lineColor2[4]={75.0/255.0f,80.0/255.0f,85.0/255.0f,1.0};
    CGContextSetStrokeColor(ctx, lineColor2);
    CGContextSetLineWidth(ctx, 1.0f);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 3,1.5f);
    CGContextAddLineToPoint(ctx, self.frame.size.width,1.5f);
    CGContextStrokePath(ctx);
    
}


@end
