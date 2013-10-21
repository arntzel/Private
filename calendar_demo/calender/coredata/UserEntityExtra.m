//
//  UserEntityExtra.m
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UserEntityExtra.h"
#import "CoreDataModel.h"

@implementation UserEntity (UserEntityExtra)

-(NSString *) getReadableUsername
{
    if(self.contact.first_name.length > 0 || self.contact.last_name.length >0) {
        return [NSString stringWithFormat:@"%@ %@", self.contact.first_name, self.contact.last_name];
    } else {
        return self.contact.email;
    }
}


-(void) convertFromUser:(EventAttendee*) atd
{
    Contact * user = atd.contact;
    
    self.id   = [NSNumber numberWithInt:user.id];
    self.is_owner      = [NSNumber numberWithBool:atd.is_owner];
    self.status        = [NSNumber numberWithInt:atd.status];
    
    ContactEntity * contact = [[CoreDataModel getInstance] getContactEntity:user.id];
    if(contact == nil) {
        contact = [[CoreDataModel getInstance] createEntity:@"ContactEntity"];
        contact.id            = [NSNumber numberWithInt:user.id];
        contact.avatar_url    = user.avatar_url;
        contact.email         = user.email;
        contact.first_name    = user.first_name;
        contact.last_name     = user.last_name;
        
        LOG_D(@"Create user entity: id=%d, email=%@", user.id, user.email);
    }
    
    self.contact = contact;
}

@end
