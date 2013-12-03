
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


-(IBAction) leftBtnSelected:(id)sender
{
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;

    if(self.delegate != nil) {
        [self.delegate onButtonSelected:0];
    }
}

-(IBAction) rigthBtnSelected:(id)sender
{
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;

    if(self.delegate != nil) {
        [self.delegate onButtonSelected:1];
    }
}


+(EventPendingToolbar*) createView {

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventPendingToolbar" owner:self options:nil];
    EventPendingToolbar * view = (EventPendingToolbar*)[nibView objectAtIndex:0];
    return view;
}

@end
