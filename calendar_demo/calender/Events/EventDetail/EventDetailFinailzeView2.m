
#import "EventDetailFinailzeView2.h"
#import "EventDetailRoundDateView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Hex.h"

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
    CALayer *bottomBorder = [CALayer layer];
    float height=self.frame.size.height-1.0f;
    float width=self.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f].CGColor;
    UIColor *color = [UIColor generateUIColorByHexString:@"#a2a5a3"];
    self.finalizedLabel.textColor = color;
    [self.layer addSublayer:bottomBorder];
}

+(EventDetailFinailzeView2 *) creatView
{
    return [self creatViewWithStartDate:nil];
}

+(EventDetailFinailzeView2 *) creatViewWithStartDate:(NSDate *)date
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventDetailFinailzeView2" owner:self options:nil];
    EventDetailFinailzeView2 * view = (EventDetailFinailzeView2*)[nibView objectAtIndex:0];
    //[view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:243.0/255.0 blue:236.0/255.0 alpha:0.7]];
    [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2]];
    [view updateUI];
    
    EventDetailRoundDateView *dateView = [[EventDetailRoundDateView alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0) withDate:date];
    [view addSubview:dateView];
    return view;
}

@end
