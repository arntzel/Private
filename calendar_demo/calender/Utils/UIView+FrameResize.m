#import "UIView+FrameResize.h"

@implementation UIView (FrameResize)

- (void)setOrginY:(NSInteger)orginY
{
    CGRect frame = self.frame;
    frame.origin.y = orginY;
    self.frame = frame;
}

- (NSInteger)getMaxY
{
    return self.frame.origin.y + self.frame.size.height;
}

@end