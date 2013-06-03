

#import "Buddy.h"
#import "Utils.h"

@implementation Buddy

+(Buddy*) parseBuddy:(NSDictionary *) json
{
    Buddy * bdy = [[Buddy alloc] init];


    bdy.id = [[json objectForKey:@"id"] intValue];
    bdy.username = [json objectForKey:@"username"];
    bdy.email = [json objectForKey:@"email"];

    bdy.first_name = [json objectForKey:@"first_name"];
    bdy.last_name = [json objectForKey:@"last_name"];
    
    bdy.date_joined = [Utils parseNSDate:[json objectForKey:@"date_joined"]];
    bdy.last_login = [Utils parseNSDate:[json objectForKey:@"last_login"]];


    return bdy;
}
@end
