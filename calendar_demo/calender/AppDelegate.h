
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer * timer;
@property (strong, nonatomic) NSTimer *uploadContactsTimer;
@property (strong, nonatomic) FBSession *session;
@end
