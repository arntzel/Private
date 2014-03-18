
#import "Contact.h"
#import "Utils.h"

@implementation Contact

-(NSComparisonResult) compare:(Contact *) ct;
{
    
    NSComparisonResult result = [self.first_name compare:ct.first_name options:NSCaseInsensitiveSearch];
    
    if(result != NSOrderedSame) {
        return result;
    }
    
    result = [self.last_name compare:ct.last_name options:NSCaseInsensitiveSearch];
    return result;
}

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

    } else if(self.email != nil){
        
        return self.email;

    } else {
        return self.phone;
    }
}


-(NSDictionary*)convent2Dic
{
    return [Contact convent2Dic:self];
}


+(Contact *) parseContact:(NSDictionary *) jsonData
{
    Contact * user = [[Contact alloc] init];

    user.id = [[jsonData objectForKey:@"id"] intValue];
    user.email = [Utils chekcNullClass:[jsonData objectForKey:@"email"]];
    if(user.email==nil) {
        user.email = @"";
    }
    
    user.avatar_url = [jsonData objectForKey:@"avatar_url"];
    if([user.avatar_url isKindOfClass: [NSNull class]]) {
        user.avatar_url = nil;
    }

    user.first_name = [jsonData objectForKey:@"first_name"];
    if([user.first_name isKindOfClass: [NSNull class]]) {
        user.first_name = nil;
    }

    user.last_name = [jsonData objectForKey:@"last_name"];
    if([user.last_name isKindOfClass: [NSNull class]]) {
        user.last_name = nil;
    }
    
    NSString * fullname = [jsonData objectForKey:@"fullname"];
    if([fullname isKindOfClass: [NSString class]]) {
        user.fullname = fullname;
    }

    
    user.phone = [Utils chekcNullClass:[jsonData objectForKey:@"phone"]];
    if(user.phone==nil) {
        user.phone = @"";
    }
    
    NSString * owner = [jsonData objectForKey:@"user"];
    user.calvinUser = [Utils chekcNullClass:owner] != nil;

    user.modified = [Utils parseNSDate:[jsonData objectForKey:@"modified"]];
    
    user.modified_num = [NSString stringWithFormat:@"%@", [jsonData objectForKey:@"modified_num"]];
    
    return user;
}

+(NSDictionary*)convent2Dic:(Contact*) user{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    [dic setObject:[NSNumber numberWithInt:user.id] forKey:@"id"];
    [dic setObject:user.email forKey:@"email"];

    if(user.avatar_url == nil)
    {
        user.avatar_url = @"";
    }

    [dic setObject:user.avatar_url forKey:@"avatar_url"];
    
    return dic;
}


@end
