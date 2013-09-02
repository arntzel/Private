//
//  UserSetting.m
//  calender
//
//  Created by fang xiang on 13-8-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UserSetting.h"
#import "User.h"
#import "Event.h"


static UserSetting * instance;

#define KEY_LASTUPDATETIME      @"lastUpdateTime"
#define KEY_LOGINUSER           @"loginUser"
#define KEY_UNREADMESSAGECOUNT  @"unreadmessagecount"
#define KEY_EVENTFILTERS        @"eventfilters"

@implementation UserSetting

+(UserSetting *) getInstance
{
    if(instance == nil) {
        instance = [[UserSetting alloc] init];
    }
    
    return instance;
}

-(void) reset
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:KEY_LOGINUSER];
    [defaults removeObjectForKey:KEY_LASTUPDATETIME];
    [defaults removeObjectForKey:KEY_UNREADMESSAGECOUNT];
    [defaults removeObjectForKey:KEY_EVENTFILTERS];

    [defaults synchronize];
}

-(User *) getLoginUserData {
    
    NSData * loginUserData = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGINUSER];

    if(loginUserData != nil) {
        NSError * err;
        NSDictionary * loginUserDic = [NSJSONSerialization JSONObjectWithData:loginUserData options:kNilOptions error:&err];
        User * loginUser = [User parseUser:loginUserDic];
        return loginUser;
    } else {
        return nil;
    }
}

-(void)saveLoginUser:(User*) loginUser
{
    
    NSDictionary * dic = [User convent2Dic:loginUser];
    NSError * err;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:KEY_LOGINUSER];
    
    [defaults synchronize];
}

-(int) getUnreadmessagecount
{
    NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UNREADMESSAGECOUNT];
    if(number == nil) {
        return 0;
    } else {
        return [number intValue];
    }
}

-(void) saveUnreadmessagecount:(int)count
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [NSNumber numberWithInt:count] forKey:KEY_UNREADMESSAGECOUNT];
    [defaults synchronize];
}


-(NSDate *) getLastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LASTUPDATETIME];
}

-(void) saveLastUpdatedTime:(NSDate*) date
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:KEY_LASTUPDATETIME];
    [defaults synchronize];
}

-(void) saveEventfilters:(int) filters
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:filters] forKey:KEY_EVENTFILTERS];
    [defaults synchronize];
}

-(int) getEventfilters
{
    NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_EVENTFILTERS];
    if(number == nil) {
        int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE;
        return filetVal;
    } else {
        return [number intValue];
    }
}
@end
