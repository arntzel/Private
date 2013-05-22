
#import "UserModel.h"
#import "Utils.h"


static UserModel * instance;

@implementation UserModel {
     User * mloginUser;
}


+(UserModel *) getInstance {

    if(instance == nil) {
        instance = [[UserModel alloc] init];
    }

    return instance;
}



-(void) createUser:(User *)user andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/createuser", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];

    
    NSLog(@"url=%@", url);

    NSString * postContent = [Utils convertObj2Json:user];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 201) {
            callback(0);
        } else {
            callback(-1);
        }
    }];
}


/**
 Login
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/login", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    
    NSLog(@"url=%@", url);


    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:username forKey:@"username_or_email"];
    [dict setObject:pwd forKey:@"password"];

    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            User * user = [User parseUser:json];
            mloginUser = user;
            callback(0, user);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) getUser:(int)userID andCallback: (void (^)(NSInteger error, User * user))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/%d", HOST, userID];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    NSLog(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            User * user = [User parseUser:json];
            callback(0, user);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) getUserProfile:(int)prifleID andCallback: (void (^)(NSInteger error, UserProfile * profile))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/userprofile/%d", HOST, prifleID];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    NSLog(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            UserProfile * profile = [UserProfile paserUserProfile:json];
            callback(0, profile);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1, nil);
        }
    }];
}

-(void) updateUserProfile:(UserProfile *) profile andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/userprofile/%d", HOST, profile.id];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];

    NSString * postContent = [Utils convertObj2Json:profile];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            callback(0);
        } else {
            //TODO:: parse error type
            //401: UNAUTHORIZED
            //Other: net work error
            callback(-1);
        }
    }];

}


/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser
{
    return mloginUser;
}

-(void) setAuthHeader:(NSMutableURLRequest *) request
{
    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", mloginUser.username, mloginUser.apikey];
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];
}

@end
