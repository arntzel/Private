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


@end
