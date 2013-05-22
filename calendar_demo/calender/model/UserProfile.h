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

@property NSString * gender;

@property NSString * self_description;

@property User * user;

+(UserProfile *) paserUserProfile:(NSDictionary *) json;

@end
