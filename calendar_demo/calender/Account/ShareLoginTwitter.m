//
//  ShareLoginDouban.m
//  MRCamera
//
//  Created by 亚 张 on 12-8-19.
//  Copyright (c) 2012年 Microrapid. All rights reserved.
//

#import "ShareLoginTwitter.h"
#import "LoginAccountStore.h"
#import "SA_OAuthTwitterController.h"

@interface ShareLoginTwitter()<SA_OAuthTwitterControllerDelegate>

@end

@implementation ShareLoginTwitter

- (void) dealloc
{
    [super dealloc];
}

- (void)shareLogin
{
    SA_OAuthTwitterController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithDelegate:self];
    [(UIViewController *)self.delegate presentViewController:controller animated:YES completion:nil];
}

- (void)shareLoginOut
{
    LoginAccountStore *accountStore = [LoginAccountStore defaultAccountStore];
    
    accountStore.twitterAccessToken = nil;
    accountStore.twitterAccessSecret = nil;
    accountStore.twitterUserName = nil;
    
    if([self.delegate respondsToSelector:@selector(shareDidLogout:)])
        [self.delegate shareDidLogout:self];
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username
{
    if([self.delegate respondsToSelector:@selector(shareDidLogin:)])
        [self.delegate shareDidLogin:self];
}
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller
{
    if([self.delegate respondsToSelector:@selector(shareDidLoginErr:)])
        [self.delegate shareDidLoginErr:self];
}
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller
{
    if([self.delegate respondsToSelector:@selector(shareDidNotLogin:)])
        [self.delegate shareDidNotLogin:self];
}
- (void) OAuthTwitterControllerNetNotWork: (SA_OAuthTwitterController *) controller
{
    if([self.delegate respondsToSelector:@selector(shareDidNotNetWork:)])
        [self.delegate shareDidNotNetWork:self];
}
- (void) OAuthTwitterControllerNetCanntReach: (SA_OAuthTwitterController *) controller
{
    if([self.delegate respondsToSelector:@selector(shareDidLoginTimeOut:)])
        [self.delegate shareDidLoginTimeOut:self];
}
@end
