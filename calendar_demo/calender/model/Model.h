
#import <Foundation/Foundation.h>
#import "User.h"

//#define HOST "http://127.0.0.1"
#define HOST "https://www.calvinapp.com"


@interface Model : NSObject


/**
 Login
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback;

/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser;


/**
 Call WebService API to get the lastest events.s
 */
-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;

+(Model *) getInstance;


@end
