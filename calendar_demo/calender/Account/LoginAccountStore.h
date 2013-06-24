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
@property(nonatomic,copy) NSString *facebookAccessToken;
@property(nonatomic,copy) NSDate *facebookExpireDate;

//twitter login info
@property(nonatomic,copy) NSString *twitterAccessToken;
@property(nonatomic,copy) NSString *twitterAccessSecret;
@property(nonatomic,copy) NSString *twitterUserName;

+(LoginAccountStore *)defaultAccountStore;

+(NSString *)accountPath;

+(void)loadAccount;

+(void)storeAccount;
@end
