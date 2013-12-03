

#import "EventAttendee.h"
#import "Utils.h"

@implementation EventAttendee

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json
{
    EventAttendee * atd = [[EventAttendee alloc] init];

    atd.id = [[json objectForKey:@"id"] intValue];
    atd.is_owner = [[json objectForKey:@"is_owner"] boolValue];
    atd.status = [[json objectForKey:@"status"] intValue];
    atd.contact  = [Contact parseContact:[json objectForKey:@"contact"]];

    atd.modified = [Utils parseNSDate:[json objectForKey:@"modified"]];
    atd.invite_key = [json objectForKey:@"invite_key"];
    return atd;
}

-(NSDictionary*) convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    [dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];
    [dic setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];

    return dic;
}

@end
