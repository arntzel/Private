

#import "CalendarIntegrationView.h"

@implementation CalendarIntegrationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(CalendarIntegrationView *) createCalendarIntegrationView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CalendarIntegrationView" owner:self options:nil];
    CalendarIntegrationView * view = (CalendarIntegrationView*)[nibView objectAtIndex:0];
    view.clipsToBounds = YES;
    view.frame = CGRectMake(0, 0, 320, CalendarIntegrationViewHeight);
    [view setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0]];
    
    return view;
}

@end
