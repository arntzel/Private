#import "AddDateTypeView.h"

@implementation AddDateTypeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(AddDateTypeView *) createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddDateTypeView" owner:self options:nil];
    AddDateTypeView * view = (AddDateTypeView*)[nibView objectAtIndex:0];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
