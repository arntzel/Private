//
//  LoginStatusCheck.m
//  Photos2
//
//  Created by mac on 12-11-25.
//  Copyright (c) 2012年 fang xiang. All rights reserved.
//

#import "LoginStatusCheck.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginAccountStore.h"

@implementation LoginStatusCheck

+(BOOL)isFacebookAccountLoginIn
{
    LoginAccountStore * accountStore = [LoginAccountStore defaultAccountStore];
    return accountStore.facebookAccessToken != nil && ![accountStore.facebookAccessToken isEqualToString:@""];
    
//    if ([FBSession activeSession].accessToken == nil || [FBSession activeSession].expirationDate == nil) {
//        return NO;
//    }
//    else
//        return YES;
}

+(BOOL)isTwitterAccountLoginIn
{
    LoginAccountStore *accountStore = [LoginAccountStore defaultAccountStore];
    if((accountStore.twitterAccessToken != nil && ![accountStore.twitterAccessToken isEqualToString:@""])&&
       (accountStore.twitterAccessSecret != nil && ![accountStore.twitterAccessSecret isEqualToString:@""]) &&
       (accountStore.twitterUserName != nil && ![accountStore.twitterUserName isEqualToString:@""]))
    {
        return YES;
    }
    else
        return NO;
}
@end
