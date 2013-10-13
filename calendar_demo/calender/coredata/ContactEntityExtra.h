//
//  ContactEntityExtra.h
//  Calvin
//
//  Created by xiangfang on 13-10-13.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactEntity.h"
#import "Contact.h"

@interface ContactEntity (ContactEntityExtra)



-(NSString *) getReadableUsername;

-(void) convertContact:(Contact *) user;

-(Contact *) getContact;

@end
