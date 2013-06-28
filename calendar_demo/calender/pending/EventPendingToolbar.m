
#import "EventPendingToolbar.h"

@implementation EventPendingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(EventPendingToolbar*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventPendingToolbar" owner:self options:nil];
    EventPendingToolbar * view = (EventPendingToolbar*)[nibView objectAtIndex:0];
    return view;
}

@end
