//
//  LoginAccountStore.h
//  Photos2
//
//  Created by mac on 12-11-25.
//  Copyright (c) 2012年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAccountStore : NSObject

//facebook login info
@property(nonatomic,retain) NSString *facebookAccessToken;
@property(nonatomic,retain) NSDate *facebookExpireDate;
@property (nonatomic, retain) NSString *facebookEmail;
//twitter login info
@property(nonatomic,retain) NSString *twitterAccessToken;
@property(nonatomic,retain) NSString *twitterAccessSecret;
@property(nonatomic,retain) NSString *twitterUserName;

+(LoginAccountStore *)defaultAccountStore;

+(NSString *)accountPath;

+(void)loadAccount;

+(void)storeAccount;
@end
