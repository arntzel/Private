//
//  UserSetting.h
//  calender
//
//  Created by fang xiang on 13-8-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

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
@end
