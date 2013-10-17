

#import <Foundation/Foundation.h>
#import "User.h"
#import "CreateUser.h"
#import "UserProfile.h"


//#define HOST "http://127.0.0.1"
#define HOST "https://www.calvinapp.com"
//#define HOST "http://54.235.240.7:3000"
//#define HOST "http://192.168.4.124:8000"

@interface UserModel : NSObject

@property(strong) NSString * device_token;

/*
 Get the single instance of UserModel object
 */
+(UserModel *) getInstance;

/**
 create user
 */
-(void) createUser:(CreateUser *)user andCallback: (void (^)(NSInteger error, NSString * msg))callback;

/*
 -Get user by userid
 */
-(void) getUser:(int)userID andCallback: (void (^)(NSInteger error, User * user))callback;


-(void) getUsers:(int)offset andCallback: (void (^)(NSInteger error, NSArray * users))callback;


-(void) getMyContacts:(NSDate *) lastmodifytime  offset:(int) offset  andCallback:(void (^)(NSInteger error, int totalCount, NSArray * contact))callback;


/*
 -Get user profile by userid
 */
-(void) getUserProfile:(int)prifleID andCallback: (void (^)(NSInteger error, UserProfile * profile))callback;

/**
 updae user profile
 */
-(void) updateUserProfile:(UserProfile *) profile andCallback:(void (^)(NSInteger error))callback;


/**
 Login with usernam and password.
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback;


/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser;

-(void) setLoginUser:(User *) user;

-(BOOL) isLogined;


/**
 Set the AUTHORIZATION http header on the http request
 */
-(void) setAuthHeader:(NSMutableURLRequest *) request;


//Begin SNS login
-(void) signinFacebook:(NSString *) accessToken andCallback:(void (^)(NSInteger error, User * user))callback;

-(void) signinGooglePlus:(NSString *)accessToken andCallback:(void (^)(NSInteger, User *))callback;


-(void) resetpassword:(NSString *) email andCallback:(void (^)(NSInteger error))callback;

@end
