
#import "EventView.h"
#import "Utils.h"
#import "ViewUtils.h"

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

-(void) refreshView:(FeedEventEntity *) event
{

    if([event.is_all_day boolValue]) {
        
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

    UserEntity * user = [event getCreator];
    NSString * headerUrl = user.avatar_url;

    //Birthday
    if([event.eventType intValue] == 4) {
        headerUrl = event.thumbnail_url;
    }

    if(headerUrl == nil) {
        self.imgUser.image = [UIImage imageNamed:@"header.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"header.png"]];
    }

    //NSString * imgName = [NSString stringWithFormat:@"colordot%d.png", event.eventType+1];
    
    int color = [self getEventTypeColor:[event.eventType intValue]];
    self.imgEventType.backgroundColor = [ViewUtils getUIColor:color];
   
    self.labAttendees.text = [self getAttendeesText:event];
    self.labLocation.text = [self getLocationText:event];
    
    self.labTitle.text = event.title;
}

-(int) getEventTypeColor:(int) eventType
{
    if( (eventType & FILTER_IMCOMPLETE) != 0) {
        return  0xFFF44258;
    }

    if( (eventType & FILTER_GOOGLE) != 0) {
        return  0xFFD5AD3E;
    }

    if( (eventType & FILTER_FB) != 0) {
        return  0xFF477DBD;
    }

    if( (eventType & FILTER_BIRTHDAY) != 0) {
        return  0xFF71A189;
    }

    return 0x00000000;
}

-(NSString *) getEventDutationText:(FeedEventEntity*)event
{
    NSMutableString * duration = [[NSMutableString alloc] init];

    if(event.duration_days>0) {
        [duration appendFormat:@"%dday ", [event.duration_days intValue]];
    }

    if(event.duration_hours>0) {
        [duration appendFormat:@"%dhr ", [event.duration_hours intValue]];
    }

    if(event.duration_minutes>0) {
        [duration appendFormat:@"%dmin ", [event.duration_minutes intValue]];
    }

    return duration;
}

-(NSString *) getLocationText:(FeedEventEntity *) event
{
    NSString * location = event.locationName;

    if(location!= nil && location.length > 0) {
        return  location;
    } else {
        return @"No location determined";
    }
}

-(NSString *) getAttendeesText:(FeedEventEntity*) event
{
    NSSet * attendees = event.attendees;
    if(attendees.count>100) {
        
        return [NSString stringWithFormat:@"%d attendees", attendees.count];
        
    } else if(attendees.count>5) {
        
        NSMutableString * str = [[NSMutableString alloc] init];

        int count = 0;
        for(UserEntity * user in attendees) {

            if(count == 0) {
                [str appendString: [user getReadableUsername]];
                [str appendString:@" "];
            } else if(count == 1) {
                [str appendString: [user getReadableUsername]];
            } else {
                break;
            }
            count++;
        }

        [str appendFormat:@" and %dattendees", attendees.count-2];
        return str;
        
    } else if(attendees.count>0){

        NSMutableString * str = [[NSMutableString alloc] init];

        int i =0 ;
        for(UserEntity * user in attendees) {
           [str appendString: [user getReadableUsername]];

            if(i<attendees.count-1) {
                [str appendString:@", "];
            }
            i++;
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
    
    view.imgEventType.layer.cornerRadius = view.imgEventType.frame.size.width/2;
    view.imgEventType.layer.masksToBounds = YES;
    
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    
    //[ViewUtils resetUILabelFont:view];
    
    return view;
}

@end
