//
//  UserSetting.m
//  calender
//
//  Created by fang xiang on 13-8-27.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "UserSetting.h"
#import "User.h"


static UserSetting * instance;

#define KEY_LASTUPDATETIME      @"lastUpdateTime"
#define KEY_LOGINUSER           @"loginUser"
#define KEY_UNREADMESSAGECOUNT  @"unreadmessagecount"


@implementation UserSetting

+(UserSetting *) getInstance
{
    if(instance == nil) {
        instance = [[UserSetting alloc] init];
    }
    
    return instance;
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
    [defaults setObject:data forKey:@"loginUser"];
    
    [defaults synchronize];
}

@end
