//
//  EventAttendee.m
//  calender
//
//  Created by xiangfang on 13-6-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "EventAttendee.h"

@implementation EventAttendee

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json
{
    EventAttendee * event = [[EventAttendee alloc] init];

    event.id = [[json objectForKey:@"id"] intValue];
    event.archived = [[json objectForKey:@"archived"] intValue];
    event.send = [[json objectForKey:@"send"] intValue];
    
    event.status = [json objectForKey:@"status"];

    //LOG_D(@"Status:%@", event.status);
    
    event.distinction = [json objectForKey:@"distinction"];
    event.suggest_end_datetime = [json objectForKey:@"suggest_end_datetime"];
    event.suggest_location = [json objectForKey:@"suggest_location"];
    event.suggest_start_datetime = [json objectForKey:@"suggest_start_datetime"];

    event.user  = [User parseUser: [json objectForKey:@"user"]];

    return event;
}
@end
