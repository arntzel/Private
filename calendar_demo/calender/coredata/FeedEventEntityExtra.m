//
//  FeedEventEntityExtra.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "FeedEventEntityExtra.h"
#import "CoreDataModel.h"

#import "UserEntityExtra.h"

@implementation FeedEventEntity (FeedEventEntityExtra)


-(UserEntity*) getCreator
{
    for(UserEntity * user in self.attendees)
    {
        if([user.id isEqualToNumber:self.createorID])
        {
            return user;
        }
    }
    
    return nil;
}


-(void) convertFromEvent:(Event*) event
{
    self.id = [NSNumber numberWithInt:event.id];
    
    self.archived =  [NSNumber numberWithBool:event.archived];
    self.confirmed =  [NSNumber numberWithBool:event.confirmed];
    self.created_on = event.created_on;
    self.descript = event.description;

    self.duration = event.duration;
    self.duration_days = [NSNumber numberWithInt:event.duration_days];
    self.duration_hours = [NSNumber numberWithInt:event.duration_hours];
    self.duration_minutes = [NSNumber numberWithInt:event.duration_minutes];

    self.eventType = [NSNumber numberWithInt:event.eventType];
    self.is_all_day =  [NSNumber numberWithBool:event.is_all_day];


    self.start = event.start;
    self.start_type = event.start_type;
    self.thumbnail_url = event.thumbnail_url;
    self.timezone = event.timezone;
    self.userstatus = event.userstatus;
    self.locationName = event.location.location;


    //UserEntity * user = [[CoreDataModel getInstance] createEntity:@"UserEntity"];
    //[user convertFromUser:event.creator];
    
    self.createorID = [NSNumber numberWithInt:event.creator.id];

    for(EventAttendee * atd in event.attendees) {

        UserEntity * atd = [[CoreDataModel getInstance] createEntity:@"UserEntity"];
        [atd convertFromUser:event.creator];
        [self addAttendeesObject:atd];
    }
}

@end
