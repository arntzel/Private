
#import "Model.h"
#import "Event.h"
#import "UserModel.h"
#import "Utils.h"


static Model * instance;

@implementation Model 

-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event", HOST];
    
    NSLog(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
   

    [[UserModel getInstance] setAuthHeader:request];
    
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


-(void) updateEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, event.id];

    NSLog(@"url=%@", url);


    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];


    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:event.title forKey:@"title"];
    [dict setObject:event.description forKey:@"description"];

    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 202) {
            callback(0);
        } else {
            callback(-1);
        }
    }];

}


-(void) deleteEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, event.id];

    NSLog(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"DELETE"];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 204) {
            callback(0);
        } else {
            callback(-1);
        }
    }];
}

/**
 Call WebService API to get messages with apikey
 */
-(void) getMessages:(void (^)(NSInteger error, NSArray* messages))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message", HOST];

    NSLog(@"url=%@", url);


    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];


    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * events = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Message * e = [Message parseMSeesage:[objects objectAtIndex:i]];
                [events addObject:e];
            }

            callback(0, events);

        } else {
            callback(-1, nil);
        }
    }];
}


-(void) updateMessage:(Message *) msg andCallback:(void (^)(NSInteger error))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message/%d", HOST, msg.id];

    NSLog(@"url=%@", url);


    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];

   //{"body": "Hey~Hey", "email": "user1@pencilme.com", "sent_at": "2012-12-12T12:12:12", "subject": "new subject"}
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:msg.body forKey:@"body"];
    [dict setObject:msg.email forKey:@"email"];
    [dict setObject:msg.subject forKey:@"subject"];
    
    NSString * sent_at = [Utils formateDate:msg.sent_at];
    [dict setObject:sent_at forKey:@"sent_at"];
    
    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 202) {
            callback(0);
        } else {
            callback(-1);
        }
    }];
}

-(void) deleteMessage:(Message *) msg andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message/%d", HOST, msg.id];

    NSLog(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"DELETE"];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 204) {
            callback(0);
        } else {
            callback(-1);
        }
    }];
}


-(void) getBuddies:(void (^)(NSInteger error, NSArray* buddies))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/buddy", HOST];

    NSLog(@"url=%@", url);


    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];


    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * buddies = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Buddy * e = [Buddy parseBuddy:[objects objectAtIndex:i]];
                [buddies addObject:e];
            }

            callback(0, buddies);
            
        } else {
            callback(-1, nil);
        }
    }];
}

-(void) deleteBuddy:(Buddy *) buddy andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/buddy/%d", HOST, buddy.id];

    NSLog(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"DELETE"];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 204) {
            callback(0);
        } else {
            callback(-1);
        }
    }];
}

-(void) createBuddy:(Buddy *) buddy andCallback:(void (^)(NSInteger error))callback
{
//TODO
}


+(Model *) getInstance
{
    if(instance == nil) {
        instance = [[Model alloc] init];
    }
    
    return instance;
}

@end
