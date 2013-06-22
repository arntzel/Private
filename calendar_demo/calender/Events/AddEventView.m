
#import "AddEventView.h"

@implementation AddEventView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (void)initAppearenceAfterLoad
{
    [self.viewEventPhoto setContentMode:UIViewContentModeScaleAspectFill];
}
@end
