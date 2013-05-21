//
//  User.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

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
   
    return user;
}

@end
