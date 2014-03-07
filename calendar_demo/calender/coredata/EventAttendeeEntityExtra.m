//
//  EventAttendeeEntityExtra.m
//  Calvin
//
//  Created by fangxiang on 14-3-5.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "EventAttendeeEntityExtra.h"
#import "Utils.h"
#import "CoreDataModel.h"

@implementation EventAttendeeEntity (EventAttendeeEntityExtra)

+(EventAttendeeEntity *) createEventAttendeeEntity:(NSDictionary *) json;
{
    if( [Utils chekcNullClass:json] == nil) {
        return nil;
    }
    
    EventAttendeeEntity * entity = [[CoreDataModel getInstance] createEntity:@"EventAttendeeEntity"];
    
    entity.id         = [json objectForKey:@"id"];
    entity.is_owner   = [json objectForKey:@"is_owner"];
    entity.status     = [json objectForKey:@"status"];
    entity.invite_key = [Utils chekcNullClass:[json objectForKey:@"invite_key"]];
    entity.created    = [Utils parseNSDate:[json objectForKey:@"created"]];
    
    NSDictionary * jsonContact = [json objectForKey:@"contact"];
    entity.first_name = [Utils chekcNullClass:[jsonContact objectForKey:@"first_name"]];
    entity.last_name  = [Utils chekcNullClass:[jsonContact objectForKey:@"last_name"]];
    entity.email      = [Utils chekcNullClass:[jsonContact objectForKey:@"email"]];
    entity.fullname   = [Utils chekcNullClass:[jsonContact objectForKey:@"fullname"]];
    entity.avatar_url = [Utils chekcNullClass:[jsonContact objectForKey:@"avatar_url"]];
   
    return entity;
}

+(EventAttendeeEntity *) createEventAttendeeEntityByEventAttendee:(EventAttendee *) eventAtd
{
    EventAttendeeEntity * entity = [[CoreDataModel getInstance] createEntity:@"EventAttendeeEntity"];
    
    entity.id         = @(eventAtd.id);
    entity.is_owner   = @(eventAtd.is_owner);
    entity.status     = @(eventAtd.status);
    entity.invite_key = eventAtd.invite_key;
    entity.created    = eventAtd.modified;
    
    Contact * contact = eventAtd.contact;
    
    entity.first_name = contact.first_name;
    entity.last_name  = contact.last_name;
    entity.email      = contact.email;
    entity.fullname   = contact.fullname;
    entity.avatar_url = contact.avatar_url;
    
    return entity;
}

@end
