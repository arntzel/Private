

#import "Event.h"
#import "Utils.h"

@implementation Event

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

    event.created_on = [Utils parseNSDate:[json objectForKey:@"created_on"]];
    event.creator  = [User parseUser: [json objectForKey:@"creator"]];
    event.description = [json objectForKey:@"description"];
    
    event.duration_days = [[json objectForKey:@"duration_days"] intValue];
    event.duration_hours = [[json objectForKey:@"duration_hours"] intValue];
    event.duration_minutes = [[json objectForKey:@"duration_minutes"] intValue];

    event.start_type = [json objectForKey:@"start_type"];
    event.start = [Utils parseNSDate:[json objectForKey:@"start"]];
    event.end = [Utils parseNSDate:[json objectForKey:@"end"]];
    event.location = [Location parseLocation: [json objectForKey:@"location"]];
    event.status = [json objectForKey:@"status"];

    event.thumbnail_url = [json objectForKey:@"thumbnail_url"];
    event.title = [json objectForKey:@"title"];
    event.userstatus = [json objectForKey:@"userstatus"];
    event.attendees = [json objectForKey:@"attendees"];

    return event;
}

@end
