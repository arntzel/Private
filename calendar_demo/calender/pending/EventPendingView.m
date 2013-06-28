
#import "EventPendingView.h"

@implementation EventPendingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setFrame:(CGRect)frame;
{
    [super setFrame:frame];

    frame.origin.y = 40;
    frame.size.height -= 40;

    self.table1.frame = frame;
    self.table2.frame = frame;
}

+(EventPendingView*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventPending" owner:self options:nil];
    EventPendingView * view = (EventPendingView*)[nibView objectAtIndex:0];
    return view;
    
}

@end
