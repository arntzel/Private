//
//  Contact.m
//  Calvin
//
//  Created by xiangfang on 13-9-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Contact.h"

@implementation Contact

-(NSString *) getReadableUsername
{
    if(self.first_name.length > 0 || self.last_name.length >0) {

        return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];

    } else {
        return self.email;
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
    user.email = [jsonData objectForKey:@"email"];

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

    user.phone = [jsonData objectForKey:@"phone"];
    
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
