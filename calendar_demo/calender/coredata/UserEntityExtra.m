//
//  UserEntityExtra.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UserEntityExtra.h"

@implementation UserEntity (UserEntityExtra)

-(NSString *) getReadableUsername
{
    if(self.first_name.length > 0 || self.last_name.length >0) {
        return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
    } else {
        return self.email;
    }
}


-(void) convertFromUser:(EventAttendee*) atd
{
    Contact * user = atd.contact;
    
    self.id            = [NSNumber numberWithInt:user.id];
    
    self.avatar_url    = user.avatar_url;
    self.email         = user.email;
    self.first_name    = user.first_name;
    self.last_name     = user.last_name;
    
    self.is_owner      = [NSNumber numberWithBool:atd.is_owner];
    self.status        = [NSNumber numberWithInt:atd.status];
    
}

@end
