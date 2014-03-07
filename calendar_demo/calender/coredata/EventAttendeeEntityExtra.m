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
    entity.first_name = [jsonContact objectForKey:@"first_name"];
    entity.last_name  = [jsonContact objectForKey:@"last_name"];
    entity.email      = [jsonContact objectForKey:@"email"];
    entity.fullname   = [Utils chekcNullClass:[jsonContact objectForKey:@"fullname"]];
    entity.avatar_url = [Utils chekcNullClass:[jsonContact objectForKey:@"avatar_url"]];
   
    return entity;
}

@end
