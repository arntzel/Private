

#import "Event.h"
#import "Utils.h"
#import "UserModel.h"

@implementation Event  {

    NSMutableDictionary * attendeesDic;
}

-(NSDictionary *) getAttendeesDic {

    if(attendeesDic == nil) {
        attendeesDic = [[NSMutableDictionary alloc] init];
        for(EventAttendee * atd in self.attendees) {
            [attendeesDic setObject:atd forKey:atd.contact.email];
        }
    }

    return attendeesDic;
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
    event.last_modified = [Utils parseNSDate:[json objectForKey:@"last_modified"]];
    event.creator  = [User parseUser: [json objectForKey:@"creator"]];
    event.description = [Utils chekcNullClass:[json objectForKey:@"description"]];

    
    event.duration = [json objectForKey:@"duration"];

    id obj = [json objectForKey:@"duration_days"];
    if(![obj isKindOfClass:[NSNull class]]) {
       event.duration_days = [obj intValue];
    }

    obj = [json objectForKey:@"duration_hours"];
    obj = [Utils chekcNullClass:obj];
    event.duration_hours = [obj intValue];


    obj = [json objectForKey:@"duration_minutes"];
    obj = [Utils chekcNullClass:obj];
    event.duration_minutes = [obj intValue];
    
    event.start_type = [json objectForKey:@"start_type"];
    
    NSDate * startDate = [Utils parseNSDate:[json objectForKey:@"start"]];
    event.start = startDate;

    //User * me = [[UserModel getInstance] getLoginUser];
    //NSTimeZone * timezone = [NSTimeZone timeZoneWithName:me.timezone];
    //event.start = [Utils gmtDate2LocatDate:startDate andTimezone:timezone];
    //event.end = [Utils parseNSDate:[json objectForKey:@"end"]];

    NSDictionary * locationDic = [Utils chekcNullClass:[json objectForKey:@"location"]];
    if(locationDic != nil) {
       event.location = [Location parseLocation:locationDic];
    }

    event.status = [json objectForKey:@"status"];

    event.thumbnail_url = [Utils chekcNullClass:[json objectForKey:@"thumbnail_url"]];
        
    event.title = [json objectForKey:@"title"];
    event.timezone = [json objectForKey:@"timezone"];

    event.userstatus = [[json objectForKey:@"userstatus"] boolValue];

    NSArray * attendeedDic =  [Utils chekcNullClass:[json objectForKey:@"attendees"]];
    NSMutableArray * attendees = [[NSMutableArray alloc] init];
    for(int i=0;i<attendeedDic.count;i++) {
        NSDictionary * dic = [attendeedDic objectAtIndex:i];
        EventAttendee * attendee = [EventAttendee parseEventAttendee:dic];
        [attendees addObject:attendee];
    }

    event.attendees = attendees;


    NSArray * propose_startsDics = [json objectForKey:@"propose_starts"];
    NSMutableArray * proposes = [[NSMutableArray alloc] init];
    for(NSDictionary * dic in propose_startsDics) {
        [proposes addObject:[ProposeStart parse:dic]];
    }
    event.propose_starts = [proposes sortedArrayUsingSelector:@selector(compare:)];
    
    event.eventType = [[json objectForKey:@"event_type"] intValue];

    event.modified_num = [NSString stringWithFormat:@"%@", [json objectForKey:@"modified_num"]];
    event.ext_event_id = [NSString stringWithFormat:@"%@", [json objectForKey:@"ext_event_id"]];
    return event;
}
-(NSDictionary*)convent2Dic
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    //[dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];

    [dic setObject:[NSNumber numberWithBool:self.allow_attendee_invite]   forKey:@"allow_attendee_invite"];
    [dic setObject:[NSNumber numberWithBool:self.allow_new_dt]            forKey:@"allow_new_dt"];
    [dic setObject:[NSNumber numberWithBool:self.allow_new_location]      forKey:@"allow_new_location"];
    //[dic setObject:[NSNumber numberWithBool:self.archived]                forKey:@"archived"];
    //[dic setObject:[NSNumber numberWithBool:self.is_all_day]              forKey:@"is_all_day"];
    [dic setObject:[NSNumber numberWithBool:self.published]               forKey:@"published"];
    //[dic setObject:[NSNumber numberWithBool:self.confirmed]               forKey:@"confirmed"];

    [dic setObject:self.ext_event_id               forKey:@"ext_event_id"];
    
    NSString * created_on = [Utils formateGMTDate:self.created_on];
    [dic setObject:created_on forKey:@"created_on"];


    //[dic setObject:[self.creator convent2Dic] forKey:@"creator"];
   
    //[dic setObject:self.duration forKey:@"duration"];
    //[dic setObject:[NSNumber numberWithInt:self.duration_days]    forKey:@"duration_days"];
    //[dic setObject:[NSNumber numberWithInt:self.duration_hours]   forKey:@"duration_hours"];
    //[dic setObject:[NSNumber numberWithInt:self.duration_minutes] forKey:@"duration_minutes"];

//    if(self.start_type != nil) {
//        [dic setObject:self.start_type forKey:@"start_type"];
//    }
    
//    if(self.start != nil) {
//        NSString * start = [Utils formateDate:self.start];
//        [dic setObject:start forKey:@"start"];
//    }
    

    if(self.location != nil) {
        [dic setObject:[self.location convent2Dic] forKey:@"location"];
    }
    
    //[dic setObject:self.status forKey:@"status"];
    if (self.thumbnail_url)
    {
        [dic setObject:self.thumbnail_url   forKey:@"thumbnail_url"];
    }
    if (self.title)
    {
        [dic setObject:self.title           forKey:@"title"];
    }
    if (self.description)
    {
        [dic setObject:self.description     forKey:@"description"];
    }
    if (self.timezone)
    {
        [dic setObject:self.timezone        forKey:@"timezone"];
    }
    

    //[dic setObject:[NSNumber numberWithInt:self.eventType] forKey:@"event_type"];

    if(self.invitees != nil && self.invitees.count > 0) {
        NSMutableArray * jsonarray = [[NSMutableArray alloc] init];
        for(Invitee * invitee in self.invitees) {
            [jsonarray addObject:[invitee convent2Dic]];
        }
        
        [dic setObject:jsonarray forKey:@"invitees"];
    }
    
    
    if(self.propose_starts != nil && self.propose_starts.count > 0)
    {
        NSMutableArray * jsonarray = [[NSMutableArray alloc] init];
        for(ProposeStart * start in self.propose_starts) {
            [jsonarray addObject:[start convent2Dic]];
        }
        
        [dic setObject:jsonarray forKey:@"propose_starts"];
    }

    
    return dic;
}

-(NSArray *) getAllContact
{
    NSMutableArray * contacts = [[NSMutableArray alloc] init];

    for(EventAttendee * atd in self.attendees)
    {
        [contacts addObject:atd.contact];
    }
    
    return contacts;
}

-(BOOL) isDeclineEvent
{
    User * me = [[UserModel getInstance] getLoginUser];
    EventAttendee * atd = [[self getAttendeesDic] objectForKey:me.email];
    return atd.status == -1;
}

-(ProposeStart *) getFinalEventTime
{
    ProposeStart * time = [[ProposeStart alloc] init];

    time.start = self.start;
    time.start_type = self.start_type;
    time.is_all_day = self.is_all_day;
    time.duration_days = self.duration_days;
    time.duration_hours = self.duration_hours;
    time.duration_minutes = self.duration_minutes;

    return time;
}

-(NSDate *) getEndTime
{
    if(self.start == nil) {
        return nil;
    }
    
    int durationSeconds =  [self getDurationMins]*60;
    return [self.start dateByAddingTimeInterval:durationSeconds];
}

-(int) getDurationMins
{
    return self.duration_minutes + self.duration_hours*60 + self.duration_days*60*24;
}
@end
