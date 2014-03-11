

#import "CreateUser.h"

@implementation CreateUser

-(NSDictionary*)convent2Dic {
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:self.username forKey:@"username"];
    [dic setObject:self.email forKey:@"email"];
    [dic setObject:self.password forKey:@"password"];
    [dic setObject:self.zip_code forKey:@"zipcode"];
    
    
    NSString * timezone = [[NSTimeZone systemTimeZone] name];
    [dic setObject:timezone forKey:@"timezone"];

    if(self.avatar_url == nil)
    {
        self.avatar_url = @"";
    }
    
    [dic setObject:self.avatar_url forKey:@"avatar_url"];
    
    if(self.first_name != nil) {
        [dic setObject:self.first_name forKey:@"first_name"];
    }
    
    if(self.last_name != nil) {
        [dic setObject:self.last_name forKey:@"last_name"];
    }
    
    return dic;
}

@end
