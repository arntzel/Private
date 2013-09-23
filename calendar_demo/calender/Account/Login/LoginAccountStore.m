//
//  LoginAccountStore.m
//  Photos2
//
//  Created by mac on 12-11-25.
//  Copyright (c) 2012年 fang xiang. All rights reserved.
//

#import "LoginAccountStore.h"
#import "EncryptUtil.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginAccountStore()

@end

@implementation LoginAccountStore
@synthesize facebookAccessToken;
@synthesize facebookExpireDate;
@synthesize twitterAccessToken;
@synthesize twitterAccessSecret;
@synthesize twitterUserName;

static LoginAccountStore *accountStore = nil;

-(id)init
{
    self = [super init];
    [self initAccount];
    return self;
}

-(void)initAccount
{
    FBSession *session = [FBSession activeSession];

    facebookAccessToken = session.accessToken;
    facebookExpireDate = session.expirationDate;
    twitterAccessSecret = nil;
    twitterAccessToken = nil;
    twitterUserName = nil;
}

+(LoginAccountStore *)defaultAccountStore
{
    if (accountStore == nil) {
        accountStore = [[LoginAccountStore alloc] init];
        [self loadAccount];
		
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
            [self storeAccount];
        }];
    }
    return accountStore;
}

+(NSString *)accountPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"account.dat"];
}

+(void)loadAccount
{
    NSString *path = [LoginAccountStore accountPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        //facebook
//        accountStore.facebookAccessToken = [EncryptUtil decryptWithText:[unarchiver decodeObjectForKey:@"facebookAccessToken"]] ;
//        accountStore.facebookExpireDate = [unarchiver decodeObjectForKey:@"facebookExpireDate"];
        
        accountStore.twitterAccessToken = [EncryptUtil decryptWithText:[unarchiver decodeObjectForKey:@"twitterAccessToken"]] ;
        accountStore.twitterAccessSecret = [EncryptUtil decryptWithText:[unarchiver decodeObjectForKey:@"twitterAccessSecret"]] ;
        accountStore.twitterUserName = [EncryptUtil decryptWithText:[unarchiver decodeObjectForKey:@"twitterUserName"]] ;
        [unarchiver finishDecoding];
        [unarchiver release];
        [data release];
    }
}

+(void)storeAccount
{
    if (accountStore == nil) {
        return;
    }
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    //Facebook
//    [archiver encodeObject:[EncryptUtil encryptWithText:accountStore.facebookAccessToken] forKey:@"facebookAccessToken"];    
//    [archiver encodeObject:accountStore.facebookExpireDate forKey:@"facebookExpireDate"];
    
    [archiver encodeObject:[EncryptUtil encryptWithText:accountStore.twitterAccessToken] forKey:@"twitterAccessToken"];
    [archiver encodeObject:[EncryptUtil encryptWithText:accountStore.twitterAccessSecret] forKey:@"twitterAccessSecret"];
    [archiver encodeObject:[EncryptUtil encryptWithText:accountStore.twitterUserName] forKey:@"twitterUserName"];
    
    [archiver finishEncoding];
    [data writeToFile:[self accountPath] atomically:YES];
    
    [archiver release];
    [data release];
}

-(void)dealloc
{
    [facebookExpireDate release];
    [facebookAccessToken release];
    
    [twitterAccessToken release];
    [twitterAccessSecret release];
    [twitterUserName release];
    
    [super dealloc];
}
@end
