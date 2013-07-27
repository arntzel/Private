
#import "AppDelegate.h"

#import "FeedViewController.h"
#import "RootNavContrller.h"
#import <GoogleMaps/GoogleMaps.h>
#import "googleAPIKey.h"
#import "SignupViewController.h"

#import "GPPURLHandler.h"

#import "UIFont+Replacement.h"

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
    [self redirectNSLogToDocumentFolder];
#endif
    
    LOG_D(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    
    [GMSServices provideAPIKey:(NSString *)googleAPIKey];
    
    [application setStatusBarHidden:NO withAnimation:NO];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    SignupViewController *viewController = [[SignupViewController alloc] init];
    
    RootNavContrller *navController = [RootNavContrller defaultInstance];
    [navController pushViewController:viewController animated:NO];


    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)registerForRemoteNotificationToGetToken
{
    NSLog(@"Registering for push notifications...");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeNewsstandContentAvailability |
          UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
    });
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken {
    
    LOG_D(@"regisger success:%@", pToken);
    
    //注册成功，将deviceToken保存到应用服务器数据库中
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self registerForRemoteNotificationToGetToken];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
