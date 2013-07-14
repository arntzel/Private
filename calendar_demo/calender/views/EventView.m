
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
    self.labLocation.text = event.location.location;


    if(event.is_all_day) {
        
        self.labTime.text = @"ALL DAY";
        self.labTimeType.hidden = YES;
        self.labEventDuration.text = @"All Day";
        
    } else {

        NSString * startType = event.start_type;
        
        if([START_TYPEEXACTLYAT isEqualToString:startType]) {

            self.labTimeType.hidden = YES;

        } else if([START_TYPEAFTER isEqualToString:startType]) {
            
            self.labTimeType.hidden = NO;
            self.labTimeType.text = @"AFTER";
            
        } else {

            self.labTimeType.hidden = NO;
            self.labTimeType.text = @"AROUND";
        }

        self.labTime.text = [Utils formateTimeAMPM:event.start];
        self.labEventDuration.text = event.duration;
    }

    NSString * headerUrl = event.creator.avatar_url;

    //Birthday
    if(event.eventType == 4) {
        headerUrl = event.thumbnail_url;
    }

    if([headerUrl isKindOfClass: [NSNull class]]) {
        self.imgUser.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }

    NSString * imgName = [NSString stringWithFormat:@"colordot%d.png", event.eventType+1];
    self.imgEventType.image = [UIImage imageNamed:imgName];

   
    self.labAttendees.text = [self getAttendeesText:event];
    self.labLocation.text = [self getLocationText:event];
}

-(NSString *) getEventDutationText:(Event*)event
{
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

    return duration;
}

-(NSString *) getLocationText:(Event *) event
{
    Location * location = event.location;

    if(location!= nil && location.location != nil && location.location.length > 0) {
        return  location.location;
    } else {
        return @"No location determined";
    }
}

-(NSString *) getAttendeesText:(Event*) event
{
    NSArray * attendees = event.attendees;
    if(attendees.count>100) {
        
        return [NSString stringWithFormat:@"%d attendees", attendees.count];
        
    } else if(attendees.count>5) {
        
        NSMutableString * str = [[NSMutableString alloc] init];

        EventAttendee * atd = [attendees objectAtIndex:0];
        [str appendString: [atd.user getReadableUsername]];
        [str appendString:@" "];
        
        atd = [attendees objectAtIndex:1];
        [str appendString: [atd.user getReadableUsername]];
       
        [str appendFormat:@" and %dattendees", attendees.count-2];

        return str;
    } else if(attendees.count>0){

        NSMutableString * str = [[NSMutableString alloc] init];

        for(int i=0;i<attendees.count;i++) {
            EventAttendee * atd = [attendees objectAtIndex:i];
            [str appendString: [atd.user getReadableUsername]];

            if(i<attendees.count-1) {
                [str appendString:@", "];
            }
        }

        return str;
    } else {
        return @"No guests invited";
    }
}


+(EventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    EventView * view = (EventView*)[nibView objectAtIndex:0];
    view.imgUser.layer.cornerRadius = view.imgUser.frame.size.width/2;
    view.imgUser.layer.masksToBounds = YES;
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    return view;
}

@end
