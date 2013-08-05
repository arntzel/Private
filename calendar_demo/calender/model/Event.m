

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
    if([event.description isKindOfClass:[NSNull class]]) {
        event.description = nil;
    }
    
    event.duration = [json objectForKey:@"duration"];

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
    if([event.thumbnail_url isKindOfClass:[NSNull class]]) {
        event.thumbnail_url = nil;
    }
        
    event.title = [json objectForKey:@"title"];
    event.timezone = [json objectForKey:@"timezone"];

    event.userstatus = [json objectForKey:@"userstatus"];

    NSArray * attendeedDic = [json objectForKey:@"attendees"];
    NSMutableArray * attendees = [[NSMutableArray alloc] init];
    for(int i=0;i<attendeedDic.count;i++) {
        NSDictionary * dic = [attendeedDic objectAtIndex:i];
        EventAttendee * attendee = [EventAttendee parseEventAttendee:dic];

        if (![@"OWNER" isEqualToString:attendee.distinction]) {
            [attendees addObject:attendee];
        }
    }

    event.attendees = attendees;

    event.eventType = [[json objectForKey:@"event_type"] intValue];

    return event;
}


-(NSDictionary*)convent2Dic
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    [dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];

    [dic setObject:[NSNumber numberWithBool:self.allow_attendee_invite]   forKey:@"allow_attendee_invite"];
    [dic setObject:[NSNumber numberWithBool:self.allow_new_dt]            forKey:@"allow_new_dt"];
    [dic setObject:[NSNumber numberWithBool:self.allow_new_location]      forKey:@"allow_new_location"];
    [dic setObject:[NSNumber numberWithBool:self.archived]                forKey:@"archived"];
    [dic setObject:[NSNumber numberWithBool:self.is_all_day]              forKey:@"is_all_day"];
    [dic setObject:[NSNumber numberWithBool:self.published]               forKey:@"published"];
    [dic setObject:[NSNumber numberWithBool:self.confirmed]               forKey:@"confirmed"];

    NSString * created_on = [Utils formateDate:self.created_on];
    [dic setObject:created_on forKey:@"created_on"];
    [dic setObject:[self.creator convent2Dic] forKey:@"creator"];
    [dic setObject:self.description forKey:@"description"];

    [dic setObject:self.duration forKey:@"duration"];
    [dic setObject:[NSNumber numberWithInt:self.duration_days]    forKey:@"duration_days"];
    [dic setObject:[NSNumber numberWithInt:self.duration_hours]   forKey:@"duration_hours"];
    [dic setObject:[NSNumber numberWithInt:self.duration_minutes] forKey:@"duration_minutes"];

    [dic setObject:self.start_type forKey:@"start_type"];

    NSString * start = [Utils formateDate:self.start];
    [dic setObject:start forKey:@"start"];

    if(self.location != nil) {
        [dic setObject:[self.location convent2Dic] forKey:@"location"];
    }
    
    [dic setObject:self.status forKey:@"status"];

    [dic setObject:self.thumbnail_url forKey:@"thumbnail_url"];
    [dic setObject:self.title forKey:@"title"];
    [dic setObject:self.userstatus forKey:@"userstatus"];
    [dic setObject:self.timezone forKey:@"timezone"];

    [dic setObject:[NSNumber numberWithInt:self.privilige] forKey:@"privilige"];
    [dic setObject:[NSNumber numberWithInt:self.eventType] forKey:@"event_type"];

    NSMutableArray * jsonarray = [[NSMutableArray alloc] init];
    for(EventAttendee * attendee in self.attendees) {
        [jsonarray addObject:[attendee convent2Dic]];
    }

    [dic setObject:jsonarray forKey:@"attendees"];

    return dic;

}

@end
