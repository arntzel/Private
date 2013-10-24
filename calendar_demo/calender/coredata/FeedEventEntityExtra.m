//
//  FeedEventEntityExtra.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "FeedEventEntityExtra.h"
#import "CoreDataModel.h"
#import "Utils.h"
#import "UserEntityExtra.h"

@implementation FeedEventEntity (FeedEventEntityExtra)


-(NSDate*) getLocalStart
{
    return [Utils convertLocalDate:self.start];
}

-(UserEntity*) getCreator
{
    for(UserEntity * user in self.attendees)
    {
        if([user.contact.email isEqualToString:self.creatoremail])
        {
            return user;
        }
    }
    
    return nil;
}


-(BOOL) isAllAttendeeResped
{
    for(UserEntity * user in self.attendees)
    {
        if([user.is_owner boolValue]) {
            continue;
        }
        
        if( [user.status intValue] != -1 && [user.status intValue] != 3) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL) isBirthdayEvent
{
    int eventType = [self.eventType intValue];
    
    return (eventType & FILTER_BIRTHDAY) != 0 ;
}

-(BOOL) isCalvinEvent
{
    int eventType = [self.eventType intValue];
    return  (eventType & FILTER_IMCOMPLETE) != 0;
}

-(void) convertFromEvent:(Event*) event
{
    self.id = [NSNumber numberWithInt:event.id];
    
    self.archived =  [NSNumber numberWithBool:event.archived];
    self.confirmed =  [NSNumber numberWithBool:event.confirmed];
    self.created_on = event.created_on;
    self.title = event.title;
    self.descript = event.description;

    self.duration = event.duration;
    self.duration_days = [NSNumber numberWithInt:event.duration_days];
    self.duration_hours = [NSNumber numberWithInt:event.duration_hours];
    self.duration_minutes = [NSNumber numberWithInt:event.duration_minutes];

    int eventType = 0x00000001 << event.eventType;
    self.eventType = [NSNumber numberWithInt:eventType];
    self.is_all_day =  [NSNumber numberWithBool:event.is_all_day];

    self.start = event.start;
    self.end = [event getEndTime];
    self.start_type = event.start_type;
    self.thumbnail_url = event.thumbnail_url;
    self.timezone = event.timezone;
    //self.userstatus = event.userstatus;
    self.locationName = event.location.location;


    self.creatorID = [NSNumber numberWithInt:event.creator.id];
    self.creatoremail = event.creator.email;
    
    [self clearAttendee];
    for(EventAttendee * atd in event.attendees) {
        UserEntity * entity = [[CoreDataModel getInstance] createEntity:@"UserEntity"];
        [entity convertFromUser:atd];
        [self addAttendeesObject:entity];
    }
    self.ext_event_id = event.ext_event_id;
    self.hasModified = @(event.hasModified);
    self.last_modified = event.last_modified;
}

-(void) convertFromCalendarEvent:(Event*) event
{
    self.id = [NSNumber numberWithInt:event.id];
    
    self.archived =  [NSNumber numberWithBool:event.archived];
    self.confirmed =  [NSNumber numberWithBool:event.confirmed];
    self.created_on = event.created_on;
    self.title = event.title;
    self.descript = event.description;
    
    self.duration = event.duration;
    self.duration_days = [NSNumber numberWithInt:event.duration_days];
    self.duration_hours = [NSNumber numberWithInt:event.duration_hours];
    self.duration_minutes = [NSNumber numberWithInt:event.duration_minutes];
    
    int eventType = 0x00000001 << event.eventType;
    self.eventType = [NSNumber numberWithInt:eventType];
    self.is_all_day =  [NSNumber numberWithBool:event.is_all_day];
    
    self.start = event.start;
    self.end = [event getEndTime];
    self.start_type = event.start_type;
    self.thumbnail_url = event.thumbnail_url;
    self.timezone = event.timezone;
    //self.userstatus = event.userstatus;
    self.locationName = event.location.location;
    
    
    self.creatorID = [NSNumber numberWithInt:event.creator.id];
    self.creatoremail = event.creator.email;
    
    [self clearAttendee];
    for(EventAttendee * atd in event.attendees) {
        UserEntity * entity = [[CoreDataModel getInstance] createEntity:@"UserEntity"];
        [entity convertFromUser:atd];
        [self addAttendeesObject:entity];
    }
    self.ext_event_id = event.ext_event_id;
    self.hasModified = @(event.hasModified);
    self.last_modified = event.last_modified;
    //NSAssert([self.hasModified boolValue]==NO, @"I have modified...");
}
-(void)clearAttendee
{
    if(self.attendees.count > 0) {
        NSSet * attendees = [[NSSet alloc] initWithSet:self.attendees];
        [self removeAttendees:attendees];
    }
}
@end
