
#import "EventDetailFinailzeView2.h"
#import "EventDetailRoundDateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailFinailzeView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateUI
{
//    [self.contentView.layer setCornerRadius:5.0f];
//    [self.contentView.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
//    [self.contentView.layer setBorderWidth:1.0f];

//    [self.layer setCornerRadius:5.0f];
//    [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.16f].CGColor];
//    [self.layer setShadowRadius:3.0f];
//    [self.layer setShadowOffset:CGSizeMake(0, 1.0f)];
    [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor];
    [self.layer setBorderWidth:1.0f];
}

+(EventDetailFinailzeView2 *) creatView
{
    return [self creatViewWithStartDate:nil];
}

+(EventDetailFinailzeView2 *) creatViewWithStartDate:(NSDate *)date
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView2" owner:self options:nil];
    EventDetailFinailzeView2 * view = (EventDetailFinailzeView2*)[nibView objectAtIndex:0];
    [view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:243.0/255.0 blue:236.0/255.0 alpha:0.7]];
    [view updateUI];
    
    EventDetailRoundDateView *dateView = [[EventDetailRoundDateView alloc]initWithFrame:CGRectMake(0.0, 8.0, 50.0, 50.0) withDate:date];
    [view addSubview:dateView];
    return view;
}

@end
