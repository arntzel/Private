

#import "User.h"

@implementation User


-(NSString *) getReadableUsername
{
    if(self.first_name.length > 0 || self.last_name.length >0) {
        if (self.first_name.length <= 0) {
            return self.last_name;
        }
        if (self.last_name.length <= 0) {
            return self.first_name;
        }

        return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];

    } else {
        return self.email;
    }
}


-(NSDictionary*)convent2Dic
{
    return [User convent2Dic:self];
}


-(BOOL) isFacebookConnected
{
    return self.facebookEmail != nil;
}

-(BOOL) isGoogleConnected
{
    return self.googleEmail != nil;
}


+(User *) parseUser:(NSDictionary *) jsonData
{
    User * user = [[User alloc] init];

    user.id = [[jsonData objectForKey:@"id"] intValue];
    user.username = [jsonData objectForKey:@"username"];
    user.email = [jsonData objectForKey:@"email"];
    
    user.apikey = [jsonData objectForKey:@"apikey"];
    if([user.apikey isKindOfClass: [NSNull class]]) {
        user.apikey = nil;
    }

    user.avatar_url = [jsonData objectForKey:@"avatar_url"];
    if([user.avatar_url isKindOfClass: [NSNull class]]) {
        user.avatar_url = nil;
    }

    user.timezone = [jsonData objectForKey:@"timezone"];
    if([user.timezone isKindOfClass: [NSNull class]]) {
        user.timezone = nil;
    }
    
    user.first_name = [jsonData objectForKey:@"first_name"];
    if([user.first_name isKindOfClass: [NSNull class]]) {
        user.first_name = nil;
    }

    user.last_name = [jsonData objectForKey:@"last_name"];
    if([user.last_name isKindOfClass: [NSNull class]]) {
        user.last_name = nil;
    }
    if (![[jsonData objectForKey:@"profile"]isKindOfClass:[NSNull class]])
    {
        user.profileUrl = [jsonData objectForKey:@"profile"];
    }
    
    if (![[jsonData objectForKey:@"social_access_token"]isKindOfClass:[NSNull class]])
    {
        if (![[[jsonData objectForKey:@"social_access_token"] objectForKey:@"facebook"] isKindOfClass:[NSNull class]])
        {
            user.facebookToken = [[[jsonData objectForKey:@"social_access_token"] objectForKey:@"facebook"] objectForKey:@"token"];
            user.facebookEmail = [[[jsonData objectForKey:@"social_access_token"] objectForKey:@"facebook"] objectForKey:@"email"];
        }
        if (![[[jsonData objectForKey:@"social_access_token"] objectForKey:@"google"] isKindOfClass:[NSNull class]])
        {
            user.googleToken = [[[jsonData objectForKey:@"social_access_token"] objectForKey:@"google"] objectForKey:@"token"];
            user.googleEmail = [[[jsonData objectForKey:@"social_access_token"] objectForKey:@"google"] objectForKey:@"email"];
        }
    }
    if ([jsonData objectForKey:@"facebookEmail"])
    {
        user.facebookEmail = [jsonData objectForKey:@"facebookEmail"];
    }
    if ([jsonData objectForKey:@"facebookToken"])
    {
        user.facebookToken = [jsonData objectForKey:@"facebookToken"];
    }
    if ([jsonData objectForKey:@"googleToken"])
    {
        user.googleToken = [jsonData objectForKey:@"googleToken"];
    }
    if ([jsonData objectForKey:@"googleEmail"])
    {
        user.googleEmail = [jsonData objectForKey:@"googleEmail"];
    }
    user.has_usable_password = [[jsonData objectForKey:@"has_usable_password"] boolValue];
    return user;
}

+(NSDictionary*)convent2Dic:(User*) user{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:[NSNumber numberWithInt:user.id] forKey:@"id"];
    [dic setObject:user.username forKey:@"username"];
    [dic setObject:user.email forKey:@"email"];
    if(user.avatar_url == nil)
    {
        user.avatar_url = @"";
    }

    [dic setObject:user.avatar_url forKey:@"avatar_url"];
    [dic setObject:user.timezone forKey:@"timezone"];

    if(user.apikey != nil) {
        [dic setObject:user.apikey forKey:@"apikey"];
    }
    
    if(user.first_name != nil) {
        [dic setObject:user.first_name forKey:@"first_name"];
    }

    if(user.last_name != nil) {
        [dic setObject:user.last_name forKey:@"last_name"];
    }
    
    if (user.profileUrl != nil)
    {
        [dic setObject:user.profileUrl forKey:@"profileUrl"];
    }
    if (user.facebookToken != nil)
    {
        [dic setObject:user.facebookToken forKey:@"facebookToken"];
    }
    if (user.facebookEmail != nil)
    {
        [dic setObject:user.facebookEmail forKey:@"facebookEmail"];
    }
    
    if (user.googleToken != nil)
    {
        [dic setObject:user.googleToken forKey:@"googleToken"];
    }
    if (user.googleEmail != nil)
    {
        [dic setObject:user.googleEmail forKey:@"googleEmail"];
    }
    [dic setObject:@(user.has_usable_password) forKey:@"has_usable_password"];
    return dic;
}

@end
