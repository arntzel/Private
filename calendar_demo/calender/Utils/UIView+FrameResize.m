#import "UIView+FrameResize.h"

@implementation UIView (FrameResize)

- (void)setOrginY:(NSInteger)orginY
{
    CGRect frame = self.frame;
    frame.origin.y = orginY;
    self.frame = frame;
}

- (NSInteger) getTop
{
    return self.frame.origin.y;
}

- (NSInteger)getMaxY
{
    return self.frame.origin.y + self.frame.size.height;
}

- (NSInteger)getMaxX
{
    return self.frame.origin.x + self.frame.size.width;
}

@end
