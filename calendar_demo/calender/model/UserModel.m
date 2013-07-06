
#import "UserModel.h"
#import "Utils.h"
#import "Model.h"

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



-(void) createUser:(CreateUser *)user andCallback:(void (^)(NSInteger error, NSString * msg))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/createuser/", HOST];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];

    
    NSLog(@"url=%@", url);

    NSString * postContent = [Utils convertObj2Json:user];
    //NSString * postContent = @"{\"username\":\"user123\", \"password\":\"111111\", \"email\":\"user123@pencilme.com\"}";
    
    NSLog(@"postContent=%@", postContent);

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 201) {
            callback(ERROCODE_OK, nil);
        } else {
            
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            NSLog(@"error=%d, resp:%@", status, json);
            callback(-1, [json objectForKey:@"error"]);
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

    [self doLogin:request andCallback:callback];
}

-(void) signinFacebook:(NSString *) accessToken andCallback:(void (^)(NSInteger error, User * user))callback
{   
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/facebook/connect/", HOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    
    
    NSLog(@"url=%@", url);
    
    NSString * postContent = [NSString stringWithFormat:@"access_token=%@", accessToken];
    NSLog(@"postContent=%@", postContent);
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];
    
    [self doLogin:request andCallback:callback];
}

-(void) signinGooglePlus:(NSString *)accessToken andCallback:(void (^)(NSInteger, User *))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/google/connect/", HOST];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    
    NSLog(@"url=%@", url);
    
    //NSString * postContent = [NSString stringWithFormat:@"access_token=%@&access_token_secret=oamFLl00vCTo7bAKmqTf1TIB", accessToken];
    NSString * postContent = [NSString stringWithFormat:@"access_token=%@", accessToken];

    NSLog(@"signinGooglePlus, postContent=%@", postContent);

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:postData];

    [self doLogin:request andCallback:callback];
}

-(void) doLogin:(NSMutableURLRequest *) request andCallback:(void (^)(NSInteger error, User * user))callback
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSLog(@"Login resp:%@", json);
            User * user = [User parseUser:json];
            mloginUser = user;
            callback(0, user);
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"error=%d, resp:%@", status, aStr);
            
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

-(void) getUsers:(int)offset andCallback: (void (^)(NSInteger error, NSArray * users))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/user/?offset=%d", HOST, offset];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    NSLog(@"url=%@", url);

    [[UserModel getInstance] setAuthHeader:request];


    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSArray * array = [json objectForKey:@"objects"];

            NSMutableArray * users =  [[NSMutableArray alloc] init];

            for(int i=0; i<array.count; i++) {
                NSDictionary * json = [array objectAtIndex:i];
                User * user = [User parseUser:json];
                [users addObject:user];
            }

            callback(0, users);
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
            callback(ERROCODE_OK);
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
    NSLog(@"authHeader:%@", authHeader);
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];
}




@end
