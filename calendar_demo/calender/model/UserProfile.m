

#import "UserProfile.h"

@implementation UserProfile

+(UserProfile *) paserUserProfile:(NSDictionary *) json
{
    UserProfile * profile = [[UserProfile alloc] init];
    profile.id = [[json objectForKey:@"id"] integerValue];
    profile.gender = [json objectForKey:@"gender"];
    profile.self_description = [json objectForKey:@"self_description"];
    profile.user = [User parseUser: [json objectForKey:@"user"]];

    return profile;
}


@end
