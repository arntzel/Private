

#import "Event.h"
#import "Utils.h"

@implementation Event


-(int) getPendingUserCount
{
    NSArray * atendees = self.attendees;

    int respCount = 0;
    int allCount = atendees.count;

    for(int i=0;i<allCount;i++) {
        EventAttendee * atd = [atendees objectAtIndex:i];
        if([atd.status isEqualToString:@"PENDING"]) {
            respCount ++;
        }
    }

    return respCount;
}


-(BOOL) isPendingStatus
{
    if(self.confirmed) return false;

    return [self getPendingUserCount] > 0;
}

+(Event *) parseEvent:(NSDictionary *) json
{
    Event * event = [[Event alloc] init];

    event.id = [[json objectForKey:@"id"] intValue];

    event.allow_attendee_invite = [[json objectForKey:@"allow_attendee_invite"] boolValue];
    event.allow_new_dt = [[json objectForKey:@"allow_new_dt"] boolValue];
    event.allow_new_location = [[json objectForKey:@"allow_new_location"] boolValue];
    event.archived = [[json objectForKey:@"archived"] boolValue];
    event.is_all_day = [[json objectForKey:@"is_all_day"] boolValue];
    event.published = [[json objectForKey:@"published"] boolValue];
    event.confirmed = [[json objectForKey:@"confirmed"] boolValue];

    event.created_on = [Utils parseNSDate:[json objectForKey:@"created_on"]];
    event.creator  = [User parseUser: [json objectForKey:@"creator"]];
    event.description = [json objectForKey:@"description"];

    id obj = [json objectForKey:@"duration_days"];
    if(![obj isKindOfClass:[NSNull class]]) {
       event.duration_days = [obj intValue];
    }

    obj = [json objectForKey:@"duration_hours"];
    if(![obj isKindOfClass:[NSNull class]]) {
        event.duration_hours = [obj intValue];
    }

    obj = [json objectForKey:@"duration_minutes"];
    if(![obj isKindOfClass:[NSNull class]]) {
        event.duration_minutes = [obj intValue];
    }
    
    event.start_type = [json objectForKey:@"start_type"];
    event.start = [Utils parseNSDate:[json objectForKey:@"start"]];
    event.end = [Utils parseNSDate:[json objectForKey:@"end"]];
    event.location = [Location parseLocation: [json objectForKey:@"location"]];
    event.status = [json objectForKey:@"status"];

    event.thumbnail_url = [json objectForKey:@"thumbnail_url"];
    event.title = [json objectForKey:@"title"];

    event.userstatus = [json objectForKey:@"userstatus"];

    NSArray * attendeedDic = [json objectForKey:@"attendees"];
    NSMutableArray * attendees = [[NSMutableArray alloc] init];
    for(int i=0;i<attendeedDic.count;i++) {
        NSDictionary * dic = [attendeedDic objectAtIndex:i];
        EventAttendee * attendee = [EventAttendee parseEventAttendee:dic];
        [attendees addObject:attendee];
    }

    event.attendees = attendees;

    event.eventType = [[json objectForKey:@"event_type"] intValue];

    return event;
}

@end
