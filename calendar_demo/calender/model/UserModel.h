

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserProfile.h"


//#define HOST "http://127.0.0.1"
#define HOST "https://www.calvinapp.com"


@interface UserModel : NSObject

+(UserModel *) getInstance;

/**
 create user
 */
-(void) createUser:(User *)user andCallback: (void (^)(NSInteger error))callback;

/*
 -Get user by userid
 */
-(void) getUser:(int)userID andCallback: (void (^)(NSInteger error, User * user))callback;


/*
 -Get user profile by userid
 */
-(void) getUserProfile:(int)prifleID andCallback: (void (^)(NSInteger error, UserProfile * profile))callback;

/**
 updae user profile
 */
-(void) updateUserProfile:(UserProfile *) profile andCallback:(void (^)(NSInteger error))callback;


/**
 Login
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback;


/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser;


/**
 Set the AUTHORIZATION http header on the http request
 */
-(void) setAuthHeader:(NSMutableURLRequest *) request;

@end
