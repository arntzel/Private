
#import "Model.h"
#import "Event.h"


static Model * instance;

@implementation Model {

    User * mloginUser;
}


/**
 Login
 */
-(void) login:(NSString *) username withPassword:(NSString *) pwd andCallback: (void (^)(NSInteger error, User * user))callback
{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%s/api/v1/user/login", HOST]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:20];

    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 
    NSLog(@"url=%@", url);

    NSString * postContent = [NSString stringWithFormat:@"{\"username_or_email\":\"%@\",\"password\":\"%@\"}", username, pwd];
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

/*
 Get the current login user, return nil if not login
 */
-(User *) getLoginUser
{
    return mloginUser;
}


-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event", HOST];
    
    NSLog(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];

    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", mloginUser.username, mloginUser.apikey];
    [request addValue:authHeader forHTTPHeaderField:@"AUTHORIZATION"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * events = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Event * e = [Event parseEvent:[objects objectAtIndex:i]];
                [events addObject:e];
            }

            callback(0, events);

        } else {
            callback(-1, nil);
        }
    }];
}

-(NSArray *) createMockupEvents {

    NSMutableArray * array = [[NSMutableArray alloc] init];

    Location * location = [[Location alloc] init];
    location.location = @"No location determined";
    User * host = [[User alloc] init];
    host.username = @"User name";

    for(int i = 0;i<5;i++) {

        NSDate * createTime = [NSDate dateWithTimeIntervalSinceNow:i*3600*24];

        Event * event = [[Event alloc] init];
        event.title = @"Dinner with roommates";
        event.eventType  = 0;
        event.creator = host;
        event.location = location;
        //event.attenedees = @"153 attendees";
        event.start = createTime;
        event.duration_minutes = 30;
        
        [array addObject:event];
    }

    return array;
}

+(Model *) getInstance
{
    if(instance == nil) {
        instance = [[Model alloc] init];
    }
    
    return instance;
}

@end
