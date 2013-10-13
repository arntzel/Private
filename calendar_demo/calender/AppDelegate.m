
#import "AppDelegate.h"

#import "FeedViewController.h"
#import "RootNavContrller.h"
#import <GoogleMaps/GoogleMaps.h>
#import "googleAPIKey.h"
#import "LoginMainViewController.h"
#import "MainViewController.h"

#import <GooglePlus/GooglePlus.h>

#import "UIFont+Replacement.h"

#import "Model.h"
#import "NSDateAdditions.h"
#import "Utils.h"
#import "UserModel.h"
#import "CoreDataModel.h"
#import "UserSetting.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (void)redirectNSLogToDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef DEBUG
    [Crashlytics startWithAPIKey:@"bf0c5f52126e61ccb51c68eecf9a761324301f9a"];
    //[self redirectNSLogToDocumentFolder];
#endif

    LOG_D(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    
    application.applicationIconBadgeNumber = 0;
    [UIApplication sharedApplication].statusBarHidden = YES;

    
    [GMSServices provideAPIKey:(NSString *)googleAPIKey];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.


    UIViewController * rootController;
    User * loginUser = [[UserSetting getInstance] getLoginUserData];
    if(loginUser != nil) {
    
        [[UserModel getInstance] setLoginUser:loginUser];
        rootController = [[MainViewController alloc] init];

    } else {
        rootController = [[LoginMainViewController alloc] init];
    }

    RootNavContrller *navController = [RootNavContrller defaultInstance];
    [navController setNavigationBarHidden:YES animated:NO];

    [navController pushViewController:rootController animated:NO];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];

    MessageModel * msgModel = [[Model getInstance] getMessageModel];
    
    int count = [[UserSetting getInstance] getUnreadmessagecount];
    [msgModel setUnReadMsgCount:count];
    
    return YES;
}

- (void)registerForRemoteNotificationToGetToken
{
    NSLog(@"Registering for push notifications...");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeNewsstandContentAvailability |
//          UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
//          UIRemoteNotificationTypeSound)];
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
    });
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"获取令牌失败:  %@",str);
    
    //如果device token获取失败则需要重新获取一次
    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(registerForRemoteNotificationToGetToken) userInfo:nil repeats:NO];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
    LOG_D(@"regisger success:%@", pToken);
    
    //注册成功，将deviceToken保存到应用服务器数据库中
    
    NSString *token = [[pToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]; //去掉"<>"
    token = [[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉中间空格
    LOG_D(@"reportToken :%@",token);

    [UserModel getInstance].device_token = token;
}

- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary * aps = [userInfo objectForKey:@"aps"];
    
    //NSDictionary *alert = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [aps objectForKey:@"alert"]];
    //int badge = [UIApplication sharedApplication].applicationIconBadgeNumber ;
    
    NSLog(@"didReceiveRemoteNotification%@", userInfo);

    int badge = [[aps objectForKey:@"badge"] integerValue];
    [[[Model getInstance] getMessageModel] setUnReadMsgCount:badge];
    //[[[Model getInstance] getMessageModel] refreshModel];
    
     [self synchronizedFromServer];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    NSLog(@"applicationDidEnterBackground");

    User * loginUser = [[UserModel getInstance] getLoginUser];
    if(loginUser != nil) {
        [[UserSetting getInstance] saveLoginUser:loginUser];
    }

    
    MessageModel * msgModel = [[Model getInstance] getMessageModel];
  
    int count = [msgModel getUnreadMsgCount];
    [[UserSetting getInstance] saveUnreadmessagecount:count];
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
     NSLog(@"applicationWillEnterForeground");
    
    [self.timer invalidate];
    self.timer = nil;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive:%d", [UIApplication sharedApplication].applicationIconBadgeNumber);

    
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber ;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if(badge>0) {
        [[[Model getInstance] getMessageModel] setUnReadMsgCount:badge];
        //[[[Model getInstance] getMessageModel] refreshModel];
    }
    
    [self registerForRemoteNotificationToGetToken];

    [self synchronizedFromServer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60
                                           target:self
                                         selector:@selector(synchronizedFromServer)
                                         userInfo:nil
                                          repeats:YES];
}


-(void) synchronizedFromServer
{
    [[[Model getInstance] getEventModel] synchronizedFromServer];

    [[[Model getInstance] getEventModel] checkContactUpdate];
}






- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
    NSLog(@"application openURL:%@", url);
    
    BOOL result = [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
    return result;
}

@end
