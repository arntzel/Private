

#import "EventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "UserEntity.h"
#import "ContactEntity.h"
#import "UIColor+Hex.h"

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

    NSString *time, *timeType, *duration;
    if([event.is_all_day boolValue]) {
        
        time = @"All Day";
        //self.labTimeType.hidden = YES;
        //self.labEventDuration.text = @"All Day";
        //self.labEventDuration.hidden = YES;
        self.labTimeStr.text = time;
    } else {

        NSString * startType = event.start_type;
        
        if([START_TYPEEXACTLYAT isEqualToString:startType]) {

            //self.labTimeType.hidden = YES;
            timeType = @"";

        } else if([START_TYPEAFTER isEqualToString:startType]) {
            
            //self.labTimeType.hidden = NO;
            timeType = @"After";
            
        } else {

            //self.labTimeType.hidden = NO;
            timeType = @"Around";
        }

        //self.labTime.text = [Utils formateTimeAMPM:[event getLocalStart]];
        
        time =[Utils formateTimeAMPM:event.start];
        duration = event.duration;
        //self.labEventDuration.text = [NSString stringWithFormat:@",%@", event.duration];
        if ((!duration) || ([duration length] == 0)) {
            if ([timeType length] == 0) {
                self.labTimeStr.text = time;
            } else {
                self.labTimeStr.text = [NSString stringWithFormat:@"%@ %@", timeType, time];
            }
        } else {
            if ([timeType length] == 0) {
                self.labTimeStr.text = [NSString stringWithFormat:@"%@,%@", time, duration];
            }else {
                self.labTimeStr.text = [NSString stringWithFormat:@"%@ %@,%@", timeType, time, duration];
            }
        }
    }

    UserEntity * user = [event getCreator];
    NSString * headerUrl = user.contact.avatar_url;

    //Birthday
    if( [event isBirthdayEvent] ) {
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
   
    
    UIColor *labelColor = [UIColor generateUIColorByHexString:@"#6b706f"];
    [self.labAttendees setTextColor:labelColor];
    [self.labLocation setTextColor:labelColor];
    self.labAttendees.text = [self getAttendeesText:event];
    self.labLocation.text = [self getLocationText:event];
    if ([self.labLocation.text isEqual: @"No Location"]) {
        [self.labLocation setHidden:YES];
        [self.iconLocation setHidden:YES];
    } else {
        [self.labLocation setHidden:NO];
        [self.iconLocation setHidden:NO];
    }
    
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

    if( (eventType & FILTER_IOS) !=0 ) {
        return 0xFFB34BAC;
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
        return @"No Location";
    }
}

-(NSString *) getAttendeesText:(FeedEventEntity*) event
{
    NSSet * attendees = event.attendees;
    return [NSString stringWithFormat:@"%d Invitees", attendees.count];
//    if(attendees.count>100) {
//        
//        return [NSString stringWithFormat:@"%d attendees", attendees.count];
//        
//    } else if(attendees.count>5) {
//        
//        NSMutableString * str = [[NSMutableString alloc] init];
//
//        int count = 0;
//        for(UserEntity * user in attendees) {
//
//            if(count == 0) {
//                [str appendString: [user getReadableUsername]];
//                [str appendString:@" "];
//            } else if(count == 1) {
//                [str appendString: [user getReadableUsername]];
//            } else {
//                break;
//            }
//            count++;
//        }
//
//        [str appendFormat:@" and %dattendees", attendees.count-2];
//        return str;
//        
//    } else if(attendees.count>0){
//
//        NSMutableString * str = [[NSMutableString alloc] init];
//
//        int i =0 ;
//        for(UserEntity * user in attendees) {
//           [str appendString: [user getReadableUsername]];
//
//            if(i<attendees.count-1) {
//                [str appendString:@", "];
//            }
//            i++;
//        }
//        
//        return str;
//    } else {
//        return @"No guests invited";
//    }
}


+(EventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    EventView * view = (EventView*)[nibView objectAtIndex:0];
    view.imgUser.layer.cornerRadius = view.imgUser.frame.size.width/2;
    view.imgUser.layer.masksToBounds = YES;
    
    // set user avatar's boarder to 1px solid #d1d9d2
    view.imgUser.layer.borderWidth = 1.0;
    view.imgUser.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
    
    view.imgEventType.layer.cornerRadius = view.imgEventType.frame.size.width/2;
    view.imgEventType.layer.masksToBounds = YES;
    
    UIColor *kalStandardColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    UIColor *kalTitleColor = [UIColor generateUIColorByHexString:@"#232525"];
    [view.labTitle setTextColor:kalTitleColor];
//    [view.labTime setTextColor:kalStandardColor];
//    [view.labTimeType setTextColor:kalStandardColor];
//    [view.labEventDuration setTextColor:kalStandardColor];
    [view.labTimeStr setTextColor:kalStandardColor];
    
    //[ViewUtils resetUILabelFont:view];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0,PlanView_HEIGHT-1);
//    CGContextSetLineWidth(context, 10.0);
//    CGContextSetLineCap(context, kCGLineCapButt);
//    CGContextSetRGBStrokeColor(context, 209, 217, 210, 1);
//    CGContextAddLineToPoint(context, 320, PlanView_HEIGHT-1);
//    CGContextStrokePath(context);
    
    view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    
    return view;
}

@end
