
#import "EventView.h"
#import "Utils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


@implementation EventView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) refreshView:(Event *) event
{
    self.labTitle.text = event.title;
    //self.labAttendees.text = event.attenedees;
    self.labLocation.text = event.location.location;

    self.labTime.text = [Utils formateTime:event.start];

    NSString * headerUrl = event.creator.avatar_url;
    
    if([headerUrl isKindOfClass: [NSNull class]]) {
        self.imgUser.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }

    
    NSMutableString * duration = [[NSMutableString alloc] init];

    if(event.duration_days>0) {
        [duration appendFormat:@"%dday ", event.duration_days];
    }

    if(event.duration_hours>0) {
        [duration appendFormat:@"%dhr ", event.duration_hours];
    }

    if(event.duration_minutes>0) {
        [duration appendFormat:@"%dmin ", event.duration_minutes];
    }

    self.labEventDuration.text = duration;

    NSString * imgName = [NSString stringWithFormat:@"colordot%d.png", event.eventType+1];
    self.imgEventType.image = [UIImage imageNamed:imgName];

}


+(EventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    EventView * view = (EventView*)[nibView objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    return view;
}

@end
