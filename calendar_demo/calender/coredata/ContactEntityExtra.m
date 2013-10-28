//
//  ContactEntityExtra.m
//  Calvin
//
//  Created by xiangfang on 13-10-13.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "ContactEntityExtra.h"

@implementation ContactEntity (ContactEntityExtra)




-(NSString *) getReadableUsername
{
//    if(self.first_name.length > 0 || self.last_name.length >0) {
//        return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
//    } else {
//        return self.email;
//    }
    
    if( self.fullname != nil) {
        return self.fullname;
    } else if(self.email != nil) {
        return self.email;
    } else if(self.phone != nil) {
        return self.phone;
    } else {
        return @"Unknown contact";
    }
}


-(void) convertContact:(Contact *) user
{
    self.id            = [NSNumber numberWithInt:user.id];

    self.avatar_url    = user.avatar_url;
    self.email         = user.email;
    self.first_name    = user.first_name;
    self.last_name     = user.last_name;
    self.phone         = user.phone;
    self.calvinuser    = [NSNumber numberWithBool:user.calvinUser];
    self.fullname      = user.fullname;
}

-(Contact *) getContact
{

    Contact * contact = [[Contact alloc] init];

    contact.id           = [self.id intValue];
    contact.avatar_url   = self.avatar_url;
    contact.email        = self.email;
    contact.first_name   = self.first_name;
    contact.last_name    = self.last_name;
    contact.phone        = self.phone;
    contact.calvinUser   = [self.calvinuser boolValue];
    contact.fullname     = self.fullname;
    return contact;
}
@end
