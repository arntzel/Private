
#import "AppDelegate.h"

#import "FeedViewController.h"
#import "RootNavContrller.h"
#import <GoogleMaps/GoogleMaps.h>
#import "googleAPIKey.h"
#import "LoginMainViewController.h"
#import "LandingViewController.h"
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
#import "MobClick.h"
#import "TestFlight.h"

#import "EventDetailController.h"
#import "CoreDataModel.h"


#define UMENG_APPKEY @"52b9916056240b31ac02ac76"

@implementation AppDelegate
@synthesize session = _session;

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
    [self redirectNSLogToDocumentFolder];
#endif
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showGuide"];
    } else {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"showGuide"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"firstLaunch"];
    }

    
    
    // start of your application:didFinishLaunchingWithOptions // ...
    [TestFlight takeOff:@"1ad5c564-019b-459f-b3a3-89d675d59e6f"];
    // The rest of your application:didFinishLaunchingWithOptions method// ...
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    //[MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    
    [MobClick startWithAppkey:UMENG_APPKEY];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];

    
    LOG_D(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxx,launchOptions=%@", launchOptions);
    
    application.applicationIconBadgeNumber = 0;

    
    [GMSServices provideAPIKey:(NSString *)googleAPIKey];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.


    UIViewController * rootController;
    User * loginUser = [[UserSetting getInstance] getLoginUserData];
    if (loginUser != nil) {
    
        [[UserModel getInstance] setLoginUser:loginUser];
        rootController = [[MainViewController alloc] init];

    }
    else {
        rootController = [[LandingViewController alloc] init];
        //rootController = [[LoginMainViewController alloc]init];
    }

    RootNavContrller *navController = [RootNavContrller defaultInstance];
    [navController setNavigationBarHidden:YES animated:NO];

    [navController pushViewController:rootController animated:NO];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];

    if(loginUser!=nil) {
        MessageModel * msgModel = [[Model getInstance] getMessageModel];
        int count = [[UserSetting getInstance] getUnreadmessagecount];
        [msgModel setUnReadMsgCount:count];
    }

    
    return YES;
}


- (void)onlineConfigCallBack:(NSNotification *)note
{
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
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
    //[[[Model getInstance] getMessageModel] refreshModel:nil];
    
    [self synchronizedEventFromServer];
    
    //Open event detail view
    if (userInfo != nil) {
        if( [Utils chekcNullClass:[userInfo objectForKey:@"event_id"]] != nil) {
            int event_id = [[userInfo objectForKey:@"event_id"] intValue];
           
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                 RootNavContrller *navController = [RootNavContrller defaultInstance];
                while (YES) {
                    //topViewController
                    UIViewController * top = navController.topViewController;
                    
                    if([top isKindOfClass:[EventDetailController class]]) {
                        
                        [navController popViewControllerAnimated:NO];
                        
                    } else {
                        break;
                    }
                }
                
               
                EventDetailController * detailView = [[EventDetailController alloc] init];
                detailView.eventID = event_id;
                [navController pushViewController:detailView animated:NO];
            });
        }
    }
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
    
    if(self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    NSLog(@"applicationWillEnterForeground");
    
//    User * loginUser = [[UserModel getInstance] getLoginUser];
//    if (loginUser != nil) {
//    
//            RootNavContrller *navController = (RootNavContrller *)self.window.rootViewController;
//            for (int i=0; i < [[navController childViewControllers] count]; i++) {
//            UIViewController *c = [[navController childViewControllers] objectAtIndex:i];
//            
//            if ([c isKindOfClass:[MainViewController class]]) {
//               
//                MainViewController *mvc = (MainViewController*)c;
//                [mvc refreshViews];
//            }
//        }
//    }
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive:%d", [UIApplication sharedApplication].applicationIconBadgeNumber);
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
    
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber ;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (badge>0) {
        
        [[[Model getInstance] getMessageModel] setUnReadMsgCount:badge];
        
        [[[Model getInstance] getMessageModel] refreshModel:^(NSInteger error) {
        }];
    }
    
    [self registerForRemoteNotificationToGetToken];
    
    
    //[self synchronizedFromServer];
    [[[Model getInstance] getEventModel] downloadServerEvents:nil];
    
    if(self.timer != nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60
                                                      target:self
                                                    selector:@selector(synchronizedFromServer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    User * loginUser = [[UserModel getInstance] getLoginUser];
    if (loginUser != nil) {
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(),  ^(void) {
            [[[Model getInstance] getEventModel] updateEventsFromLocalDevice];
        });
    }
    
    [[[Model getInstance] getEventModel] synchronizedDeletedEvent];
}


-(void) synchronizedFromServer
{
    //[[[Model getInstance] getEventModel] downloadServerEvents:nil];
    [[[Model getInstance] getEventModel] checkContactUpdate];
}

-(void) synchronizedEventFromServer
{
    [[[Model getInstance] getEventModel] downloadServerEvents:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
    BOOL result = NO;
    
    if([@"com.facebook.Facebook" isEqualToString:sourceApplication]) {
        
       result = [FBAppCall handleOpenURL:url
                     sourceApplication:sourceApplication
                        fallbackHandler:^(FBAppCall *call) {
                                NSLog(@"In fallback handler");
              }];
        
    } else {
        
        result = [GPPURLHandler handleURL:url
                             sourceApplication:sourceApplication
                                    annotation:annotation];
    }
    
    LOG_D(@"From [%@] result=%d openURL:%@", sourceApplication, result, url);
    
    return result;
}

@end
