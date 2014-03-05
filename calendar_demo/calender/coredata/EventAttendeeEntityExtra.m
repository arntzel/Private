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
    entity.first_name = [json objectForKey:@"first_name"];
    entity.last_name  = [json objectForKey:@"last_name"];
    entity.email      = [json objectForKey:@"email"];
    entity.fullname   = [Utils chekcNullClass:[json objectForKey:@"fullname"]];
    entity.is_owner   = [json objectForKey:@"is_owner"];
    entity.status     = [json objectForKey:@"status"];
    entity.invite_key = [Utils chekcNullClass:[json objectForKey:@"invite_key"]];
    entity.avatar_url = [Utils chekcNullClass:[json objectForKey:@"avatar_url"]];
    entity.created    = [Utils parseNSDate:[json objectForKey:@"created"]];

    return entity;
}

@end
