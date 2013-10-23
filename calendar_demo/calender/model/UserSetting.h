//
//  UserSetting.h
//  calender
//
//  Created by fang xiang on 13-8-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define KEY_LASTUPDATETIME            @"lasteventUpdateTime"
#define KEY_LOGINUSER                 @"loginUser"
#define KEY_UNREADMESSAGECOUNT        @"unreadmessagecount"
#define KEY_EVENTFILTERS              @"eventfilters"
#define KEY_CONTACTUPDATETIME         @"lastcontactupdatetime"
#define KEY_TIMEZONE                  @"timezone"

@interface UserSetting : NSObject

+(UserSetting *) getInstance;

-(void) reset;


-(User *) getLoginUserData ;

-(void)saveLoginUser:(User*) loginUser;


-(int) getUnreadmessagecount;

-(void) saveUnreadmessagecount:(int)count;


-(NSDate *) getLastUpdatedTime;

-(void) saveLastUpdatedTime:(NSDate*) date;


-(void) saveEventfilters:(int) filters;

-(int) getEventfilters;

-(NSString *) getTimezone;

-(void) saveTimeZone:(NSString *) timezone;

-(void) saveKey:(NSString *) key andIntValue:(int) value;
-(int) getIntValue:(NSString *) key;

-(void) saveKey:(NSString *) key andStringValue:(NSString *) value;
-(NSString *) getStringValue:(NSString *) key;

@end
