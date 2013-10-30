
#import "EventTimeVote.h"
#import "Utils.h"

@implementation EventTimeVote


-(NSDictionary*) convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];
    [dic setObject:self.email forKey:@"username_or_email"];
    return dic;

}

+(EventTimeVote *) parse:(NSDictionary *) json
{
    EventTimeVote * vote = [[EventTimeVote alloc] init];
    vote.status = [[json objectForKey:@"status"] intValue];
    vote.email = [json objectForKey:@"username_or_email"];
    return vote;
}

@end
