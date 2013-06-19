//
//  UserProfile.h
//  calender
//
//  Created by xiangfang on 13-5-22.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface UserProfile : NSObject

@property int id;

@property(strong) NSString * gender;

@property(strong) NSString * self_description;

@property(strong) User * user;

+(UserProfile *) paserUserProfile:(NSDictionary *) json;

@end
