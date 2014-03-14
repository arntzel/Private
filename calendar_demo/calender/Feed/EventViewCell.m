//
//  EventViewCell.m
//  Calvin
//
//  Created by Yevgeny on 3/2/14.
//  Copyright (c) 2014 Pencil Me, Inc. All rights reserved.
//

#import "EventViewCell.h"
#import "EventView.h"
#import "Utils.h"
#import "ViewUtils.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "CreatorEntity.h"
#import "ContactEntity.h"
#import "UIColor+Hex.h"

#import "EventAttendeeEntity.h"

#define TAG_INV_START 1000
#define TAG_INV_END   1003


@implementation EventViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(float)getEventViewHeight
{
    float dynamicEventViewHeight = self.iconAttendee.frame.origin.y + self.iconAttendee.frame.size.height+25;
    return dynamicEventViewHeight;
}

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay
{
    self.separator.hidden = lastForThisDay;
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    // set user avatar's boarder to 1px solid #d1d9d2
    self.imgUser.layer.borderWidth = 1.0;
    self.imgUser.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
    
    self.imgEventType.layer.cornerRadius = self.imgEventType.frame.size.width/2;
    self.imgEventType.layer.masksToBounds = YES;
    
    NSString *time, *duration;
    if([event.is_all_day boolValue]) {
        
        time = @"All Day";
        self.labTimeStr.text = time;
    }
    else {
        //self.labTime.text = [Utils formateTimeAMPM:[event getLocalStart]];
        time =[Utils formateTimeAMPM:event.start];
        duration = event.duration;
        self.labTimeStr.text = [NSString stringWithFormat:@"%@", time];
    }

    NSMutableArray *userArray = [NSMutableArray array];
    
    if( [event isBirthdayEvent]) {
        
        self.labTimeStr.text = @"All Day";
        
        NSString * headerUrl = event.thumbnail_url;
        
        [userArray addObject:headerUrl];
    }
    else
    {
        //NSLog(@"event.title=%@", event.title);
        //NSLog(@"event.attendees=%@", event.attendees);
        for (EventAttendeeEntity *attend in event.attendees)
        {
            NSString *avatar_ur = attend.avatar_url;
            if (avatar_ur == nil) {
                avatar_ur = @"";
            }
            [userArray addObject:avatar_ur];
        }
    }
    
    for (int i=TAG_INV_START; i < TAG_INV_END; i++) {
        UIImageView *v = (UIImageView*)[self.inviteesPanel viewWithTag:i];
        if (v) {
            v.hidden = YES;
     
            int attendeeIndex = i - TAG_INV_START;
            
            if (attendeeIndex < [userArray count])
            {
                NSString *avatar_url = userArray[attendeeIndex];
                
                NSString  *headerUrl = avatar_url;
                
                v.hidden = NO;
                v.layer.cornerRadius = self.imgUser.frame.size.width/2;
                v.layer.masksToBounds = YES;
                v.layer.borderWidth = 1.0;
                v.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
                
                if ([headerUrl length] < 1) {
                    v.image = [UIImage imageNamed:@"default_person.png"];
                }
                else
                {
                    [v setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"default_person.png"]];
                }
            }
        }
    }
    
    int color = [self getEventTypeColor:[event.eventType intValue]];
    
    self.imgEventType.backgroundColor = [ViewUtils getUIColor:color];
    
    UIColor *labelColor = [UIColor generateUIColorByHexString:@"#6b706f"];
    [self.labAttendees setTextColor:labelColor];
    [self.labLocation setTextColor:labelColor];
    
    self.labAttendees.text = [self getAttendeesText:event];
    self.labLocation.text = [self getLocationText:event];
    
    if ([self.labLocation.text isEqual: @"No Location"]) {
        
        CGRect frame = self.inviteesPanel.frame;
        frame.origin.y = 30;
        self.inviteesPanel.frame = frame;
        
        [self.labLocation setHidden:YES];
        [self.iconLocation setHidden:YES];
        
    } else {
        
        CGRect frame = self.inviteesPanel.frame;
        frame.origin.y = 44;
        self.inviteesPanel.frame = frame;
        
        [self.labLocation setHidden:NO];
        [self.iconLocation setHidden:NO];
    }
    
    self.labTitle.text = event.title;
}

//TODO::
-(int) getEventTypeColor:(int) eventType
{
    return  [ViewUtils getEventTypeColor:eventType];
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
    return [NSString stringWithFormat:@"%d Invitees", [event.attendee_num intValue]];
}

/*
+(EventView *) createEventView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"EventView" owner:self options:nil];
    EventView * view = (EventView*)[nibView objectAtIndex:0];
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
    // set user avatar's boarder to 1px solid #d1d9d2
    self.imgUser.layer.borderWidth = 1.0;
    self.imgUser.layer.borderColor = [[UIColor generateUIColorByHexString:@"#d1d9d2"] CGColor];
    
    view.imgEventType.layer.cornerRadius = view.imgEventType.frame.size.width/2;
    view.imgEventType.layer.masksToBounds = YES;
    
    UIColor *kalStandardColor = [UIColor generateUIColorByHexString:@"#18a48b"];
    //    UIColor *kalTitleColor = [UIColor generateUIColorByHexString:@"#232525"];
    //    [view.labTitle setTextColor:kalTitleColor];
    [view.labTimeStr setTextColor:kalStandardColor];
    
    //view.frame = CGRectMake(0, 0, 320, PlanView_HEIGHT);
    
    return view;
}
 */

@end
