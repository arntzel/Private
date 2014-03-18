//
//  Invitee.h
//  Calvin
//
//  Created by fang xiang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Invitee : NSObject

@property(strong) NSString * email;

@property(strong) Contact * contact;

-(NSDictionary*)convent2Dic;

@end
