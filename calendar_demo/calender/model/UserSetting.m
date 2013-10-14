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
#import "CoreDataModel.h"
#import "Utils.h"

static UserSetting * instance;



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
    Setting * setting = [[CoreDataModel getInstance] getSetting:KEY_UNREADMESSAGECOUNT];
    if(setting == nil) {
        return 0;
    } else {
        return [setting.value intValue];
    }
}

-(void) saveUnreadmessagecount:(int)count
{
    [[CoreDataModel getInstance] saveSetting:KEY_UNREADMESSAGECOUNT andValue: [NSString stringWithFormat:@"%d", count]];
}


-(NSDate *) getLastUpdatedTime
{
    
    Setting * setting = [[CoreDataModel getInstance] getSetting:KEY_LASTUPDATETIME];
    if(setting == nil) {
        return nil;
    } else {
        return [Utils parseNSDate:setting.value];
    }
}

-(void) saveLastUpdatedTime:(NSDate*) date
{
    NSString * val = [Utils formateDate:date];
    [[CoreDataModel getInstance] saveSetting:KEY_LASTUPDATETIME andValue: val];
}

-(void) saveEventfilters:(int) filters
{
    [[CoreDataModel getInstance] saveSetting:KEY_EVENTFILTERS andValue: [NSString stringWithFormat:@"%d", filters]];
}

-(int) getEventfilters
{
    Setting * setting = [[CoreDataModel getInstance] getSetting:KEY_EVENTFILTERS];
    if(setting == nil) {
        int filetVal = FILTER_BIRTHDAY | FILTER_FB | FILTER_IMCOMPLETE | FILTER_GOOGLE;
        return filetVal;
    } else {
        return [setting.value intValue];
    }
}

-(NSString *) getTimezone
{
    Setting * setting = [[CoreDataModel getInstance] getSetting:KEY_TIMEZONE];
    if(setting == nil) {
        return nil;
    } else {
        return setting.value;
    }
}

-(void) saveTimeZone:(NSString *) timezone
{
    [[CoreDataModel getInstance] saveSetting:KEY_TIMEZONE andValue:timezone];

}

@end
