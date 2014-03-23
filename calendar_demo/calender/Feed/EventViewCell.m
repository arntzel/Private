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
#import "UserModel.h"

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

}

-(void) refreshView:(FeedEventEntity *) event lastForThisDay:(BOOL)lastForThisDay
{
    self.separator.hidden = lastForThisDay;
    
    self.imgUser.layer.cornerRadius = self.imgUser.frame.size.width/2;
    self.imgUser.layer.masksToBounds = YES;
    
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
            User *u = [[UserModel getInstance] getLoginUser];
            if ([u.email isEqualToString:attend.email]) {
                //NSLog(@"--------> %@    %@", attend.id, attend.email);
                continue;
            }
            
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
    
    BOOL weHaveLocation = YES;
    if ([self.labLocation.text length] < 1) {
        weHaveLocation = NO;
    }

    CGRect frame = self.inviteesPanel.frame;
    
    if (weHaveLocation == NO) {
        
        frame.origin.y = 30;
        self.inviteesPanel.frame = frame;
        
        [self.labLocation setHidden:YES];
        [self.iconLocation setHidden:YES];
        
    }
    else {
        
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
    
    if (location != nil && location.length > 0) {
        return location;
    }
    else {
        return @"";
    }
}

-(NSString *) getAttendeesText:(FeedEventEntity*) event
{
    return [NSString stringWithFormat:@"%d Invitees", [event.attendee_num intValue]];
}

+(eventCellHeightType) cellHeightType:(FeedEventEntity *) event
{
    eventCellHeightType heightType = eventCellTitle;
    
    if ([event.is_all_day boolValue]) {
    }
    else {
    }
    
    if ( [event isBirthdayEvent])
    {
        heightType = eventCellTitleInvitees;
    }
    else
    {
        //NSLog(@"event.title=%@", event.title);
        //NSLog(@"event.attendees=%@", event.attendees);
        for (EventAttendeeEntity *attend in event.attendees)
        {
            User *u = [[UserModel getInstance] getLoginUser];
            if ([u.email isEqualToString:attend.email]) {
                //NSLog(@"--------> %@    %@", attend.id, attend.email);
                continue;
            }
            heightType = eventCellTitleInvitees;
        }
    }
    
    NSString * location = event.locationName;
    if (location != nil && location.length > 0) {
        //yes location
        
        if (heightType == eventCellTitleInvitees) {
            heightType = eventCellTitleLocationInvitees;
        }
        else
        {
            heightType = eventCellTitleLocation;            
        }
    }
    
    return heightType;
}

@end
