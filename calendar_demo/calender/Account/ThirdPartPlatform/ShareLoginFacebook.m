
#import "ShareLoginFacebook.h"
#import "LoginAccountStore.h"
#import "User.h"
#import "UserModel.h"

@implementation ShareLoginFacebook



+ (BOOL)isFacebookLoginIn{
    LoginAccountStore *accountStore = [LoginAccountStore defaultAccountStore];
    if (accountStore.facebookAccessToken != nil && ![accountStore.facebookAccessToken isEqualToString:@""]
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }

    
    
    LOG_METHOD;
    if (![FBSession activeSession].isOpen) {
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        
        LOG_D(@"TokenLoaded start");
        if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [[FBSession activeSession] openWithCompletionHandler:nil];
            LOG_D(@"TokenLoaded end");
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

- (void) dealloc
{
    [super dealloc];
}

- (void)shareLogin
{
    LOG_METHOD;
    // this button's job is to flip-flop the session from open to closed
    if (FBSession.activeSession.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    
    if ([FBSession activeSession].state != FBSessionStateCreated) {
        // Create a new, logged out session.
        NSArray *permissions = [NSArray arrayWithObjects:
                                @"user_likes",
                                @"publish_actions",
                                nil];
        FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
        [FBSession setActiveSession:session];
    }
    [self loginInWebView];
}

- (void)loginResult:(FBSession *)session statue:(FBSessionState) status Error:(NSError *)error
{
    if(error.code == -1009)
    {//无网络
        LOG_D(@"error.code: -1009");
        if([self.delegate respondsToSelector:@selector(shareDidNotNetWork:)])
            [self.delegate shareDidNotNetWork:self];
    }
    else if(error.code == -1001)
    {//超时
        LOG_D(@"error.code: -1001");
        if([self.delegate respondsToSelector:@selector(shareDidLoginTimeOut:)])
            [self.delegate shareDidLoginTimeOut:self];
    }
    else if(error.code == -1003)
    {//找不到服务器
        LOG_D(@"error.code: -1003");
        if([self.delegate respondsToSelector:@selector(shareDidLoginTimeOut:)])
            [self.delegate shareDidLoginTimeOut:self];
    }
    else if(error.code != 0)
    {
        if([self.delegate respondsToSelector:@selector(shareDidLoginErr:)])
            [self.delegate shareDidLoginErr:self];
    }
    else
    {
        LoginAccountStore *accountStore = [LoginAccountStore defaultAccountStore];
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
         {
             if (!error)
             {
                 accountStore.facebookAccessToken = session.accessToken;
                 accountStore.facebookExpireDate = session.expirationDate;
                 accountStore.facebookEmail = [user objectForKey:@"email"];
                 if([self.delegate respondsToSelector:@selector(shareDidLogin:)])
                     [self.delegate shareDidLogin:self];
             }
         }];
    }
}

- (void)loginInWebView
{
    [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView
                              completionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error)
     {
         [self loginResult:session statue:status Error:error];
     }];
}

- (void)shareLoginOut
{
    if ([FBSession activeSession].isOpen)
    {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    
    LoginAccountStore *accountStore = [LoginAccountStore defaultAccountStore];
    accountStore.facebookAccessToken = nil;
    accountStore.facebookExpireDate = nil;
    
    if([self.delegate respondsToSelector:@selector(shareDidLogout:)])
        [self.delegate shareDidLogout:self];
}
@end
