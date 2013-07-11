

#import "User.h"

@implementation User



+(User *) parseUser:(NSDictionary *) jsonData
{
    User * user = [[User alloc] init];

    user.id = [[jsonData objectForKey:@"id"] intValue];
    user.username = [jsonData objectForKey:@"username"];
    user.email = [jsonData objectForKey:@"email"];
    user.apikey = [jsonData objectForKey:@"apikey"];
    user.avatar_url = [jsonData objectForKey:@"avatar_url"];
    user.timezone = [jsonData objectForKey:@"timezone"];

    return user;
}

+(NSDictionary*)convent2Dic:(User*) user{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInt:user.id] forKey:@"id"];
    [dic setObject:user.username forKey:@"username"];
    [dic setObject:user.email forKey:@"email"];
    [dic setObject:user.avatar_url forKey:@"avatar_url"];
    [dic setObject:user.timezone forKey:@"timezone"];
    
    return dic;
}

@end
