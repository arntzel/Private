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
    }
    return self;
}

-(float)getEventViewHeight
{
    float dynamicEventViewHeight = self.iconAttendee.frame.origin.y + self.iconAttendee.frame.size.height+25;
    return dynamicEventViewHeight;
}

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay
{
    self.separator.hidden = lastForThisDay;
    
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
            timeType = @"Exactly at";

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
        BOOL isExactlyType = [event.start_type isEqualToString:START_TYPEEXACTLYAT] ? YES: NO;
        //self.labEventDuration.text = [NSString stringWithFormat:@",%@", event.duration];
        if (isExactlyType) {
            NSString *endTime = [Utils formateTimeAMPM:event.end];
            self.labTimeStr.text = [NSString stringWithFormat:@"%@ %@ to %@", timeType, time, endTime];
        } else {
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
    }

    UserEntity * user = [event getCreator];
    NSString * headerUrl = user.contact.avatar_url;

    //Birthday
    if( [event isBirthdayEvent] ) {
        self.labTimeStr.text = @"Exactly At";
        headerUrl = event.thumbnail_url;
    }

    if(headerUrl == nil) {
        self.imgUser.image = [UIImage imageNamed:@"default_person.png"];
    } else {
        [self.imgUser setImageWithURL:[NSURL URLWithString:headerUrl]
                     placeholderImage:[UIImage imageNamed:@"default_person.png"]];
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
    
    CGSize maxSize = CGSizeMake(self.labTitle.frame.size.width, 1000.0f);
    CGSize fontSize = [event.title sizeWithFont:self.labTitle.font constrainedToSize:maxSize lineBreakMode:self.labTitle.lineBreakMode];
    
    [self.labTitle setNumberOfLines:0];
    self.labTitle.text = event.title;
    CGRect strFrame = CGRectMake(0, 18, 210, fontSize.height);
    self.labTitle.frame = strFrame;
    
//    CGRect labTitleFrame = self.labTitle.frame;
//    labTitleFrame.origin.y = self.labTimeStr.frame.origin.y + 5;
//    self.labTitle.frame = labTitleFrame;
    //self.labTitle.backgroundColor = [UIColor greenColor];
    
    
    float metaY = strFrame.origin.y + fontSize.height + 5;
    
//    CGRect iconUserFrame = self.iconUser.frame;
//    iconUserFrame.origin.y = metaY;
    
    CGRect iconLocationFrame = self.iconLocation.frame;
    iconLocationFrame.origin.y = metaY;
    
    CGRect labAttendeesFrame = self.labAttendees.frame;
    labAttendeesFrame.origin.y = metaY - 3;
    
    CGRect labLocationFrame = self.labLocation.frame;
    labLocationFrame.origin.y = metaY - 3;
    
    CGRect iconAttedeeFrame = self.iconAttendee.frame;
    iconAttedeeFrame.origin.y = metaY;
    
    //self.iconUser.frame = iconUserFrame;
    self.iconLocation.frame = iconLocationFrame;
    self.labLocation.frame = labLocationFrame;
    self.labAttendees.frame = labAttendeesFrame;
    self.iconAttendee.frame = iconAttedeeFrame;
    
    
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.size.height = self.iconAttendee.frame.origin.y + 12;
    contentViewFrame.origin.y = 10;//25;
    self.contentView.frame = contentViewFrame;
    
    //NSLog(@"event title:%@, height:%f, contentView.height=%f, fontSizeHeight=%f", event.title, fontSize.height, contentViewFrame.size.height, fontSize.height);
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
    [view.labTimeStr setTextColor:kalStandardColor];
    
    //view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    
    return view;
}

@end
