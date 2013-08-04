//
//  UserEntityExtra.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UserEntityExtra.h"
#import "UserEntity.h"
#import "User.h"

@implementation UserEntity (UserEntityExtra)

-(void) convertFromUser:(User*) user
{

    self.id = [NSNumber numberWithInt:user.id];
    self.apikey = user.apikey;
    self.avatar_url = user.avatar_url;
    self.email = user.email;
    self.first_name = user.first_name;
    self.last_name = user.last_name;
    self.timezone = user.timezone;
    self.username = user.username;
}

@end
