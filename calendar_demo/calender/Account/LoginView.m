

#import "LoginView.h"

@implementation LoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(LoginView *) createView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    LoginView * view = (LoginView*)[nibView objectAtIndex:0];
    return view;
}

@end
