
#import "Model.h"
#import "Event.h"
#import "UserModel.h"
#import "Utils.h"


static Model * instance;

@implementation Model  {
    EventModel * eventModel;
}

-(id) init {
    self = [super init];
    eventModel = [[EventModel alloc] init];
    return self;
}

/*
 {
 allow_attendee_invite: false,
 allow_new_dt: false,
 
 invitees:
 [

 {
 email: "zhiwehu@gmail.com",
 username: "zhiwehu"
 },

 ...
 ],

 description: "*",
 duration_days: 0,
 duration_hours: null,
 duration_minutes: null,
 event_type: 0,
 is_all_day: false,
 location: { lat（维度）, lng(经度), location},
 published: true,
 start: "2013-06-12T09:45:18",
 start_type: "exactly_at",
 thumbnail_url: null,
 timezone: "Asia/Chongqing",
 title: "YouTube Livestream from the AngularJS-MTV Meetup"
 },
 */
-(void) createEvent:(Event *) evt andCallback:(void (^)(NSInteger error, Event * newEvt))callback
{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[NSNumber numberWithBool:evt.allow_attendee_invite] forKey:@"allow_attendee_invite"];
    [dict setObject:[NSNumber numberWithBool:evt.allow_new_dt] forKey:@"allow_new_dt"];

    NSMutableArray * invitees =  [[NSMutableArray alloc] init];

    for(int i=0; i<evt.attendees.count; i++) {
        EventAttendee * atd = [evt.attendees objectAtIndex:i];

        NSMutableDictionary * userDic = [[NSMutableDictionary alloc] init];
        [userDic setObject:atd.user.email forKey:@"email"];
        [userDic setObject:atd.user.username forKey:@"username"];

        [invitees addObject:userDic];
    }

    [dict setObject:invitees forKey:@"invitees"];


    NSMutableDictionary * location =  [[NSMutableDictionary alloc] init];
    [location setObject:evt.location.location forKey:@"location"];
    [location setObject:[NSNumber numberWithFloat:evt.location.lat]  forKey:@"lat"];
    [location setObject:[NSNumber numberWithFloat:evt.location.lng]  forKey:@"lng"];
    [dict setObject:location forKey:@"location"];

    [dict setObject:evt.description forKey:@"description"];

    [dict setObject:[NSNumber numberWithInt:evt.duration_days] forKey:@"duration_days"];
    [dict setObject:[NSNumber numberWithInt:evt.duration_hours] forKey:@"duration_hours"];
    [dict setObject:[NSNumber numberWithInt:evt.duration_minutes] forKey:@"duration_minutes"];
    
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"event_type"];

    [dict setObject:[NSNumber numberWithBool:evt.is_all_day] forKey:@"is_all_day"];
    [dict setObject:[NSNumber numberWithBool:true] forKey:@"published"];

    
    NSString * start = [Utils formateDate:evt.start];
    [dict setObject:start forKey:@"start"];

    //FOR TEST
    [dict setObject:start forKey:@"end"];
    
    [dict setObject:evt.start_type forKey:@"start_type"];
    [dict setObject:evt.thumbnail_url forKey:@"thumbnail_url"];
    [dict setObject:evt.title forKey:@"title"];
    [dict setObject:evt.timezone forKey:@"timezone"];

    NSString * postContent = [Utils dictionary2String:dict];

    NSLog(@"createEvent, postContent:%@", postContent);

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/", HOST];

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    [[UserModel getInstance] setAuthHeader:request];

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 201) {
            
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            NSLog(@"Login resp:%@", json);

            Event * newEvent = [Event parseEvent:json];
            callback(0, newEvent);
            
        } else {

            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"error=%@, resp:%@", error, aStr);

            callback(-1, nil);
        }
    }];    
}


-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger iCurYear = [components year];  //当前的年份
    NSInteger iCurMonth = [components month];  //当前的月份
    [self getEvents:iCurYear andMonth:iCurMonth andCallback:callback];
}


-(void) getEvents:(int) year andMonth:(int) month andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
       
    NSString * startDay = [Utils formate:year andMonth:month];
    
    month++;
    if(month>12) {
        month = 1;
        year ++;
    }
    
    NSString * endDay = [Utils formate:year andMonth:month];
    
    startDay =[NSString stringWithFormat:@"%@-01T00:00:00", startDay];
    endDay =[NSString stringWithFormat:@"%@-01T00:00:00", endDay];
    
    [self getEvents:startDay andEnd:endDay andCallback:callback];
}

-(void) getEvents:(NSString *)startDay andEnd:(NSString *)endDay  andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
    //start__gte=2013-06-15T00:00:00
    //start__lt=2013-06-16T00:00:00

    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?start__gte=%@&start__lt=%@", HOST, startDay, endDay];
    
    NSLog(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
    
    [self getEvents:request andCallback:callback];
}

-(void) getEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback
{
    NSString * currentDate = [Utils formateDay: [NSDate date]];
    //User * me = [[UserModel getInstance] getLoginUser];
    //NSString  * encodedName = [me.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&creator=%@", HOST, currentDate, encodedName];
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&event_type=0", HOST, currentDate];

    NSLog(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    [self getEvents:request andCallback:callback];
}

-(void) getRelativeEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback
{
    
    NSString * currentDate = [Utils formateDay: [NSDate date]];
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&attendee_status=PENDING", HOST, currentDate];
    
    NSLog(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
    
    [self getEvents:request andCallback:callback];
}

-(void) getEvents:(NSMutableURLRequest *) request  andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
    [[UserModel getInstance] setAuthHeader:request];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 200) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            NSLog(@"Event resp:%@", json);

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * events = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Event * e = [Event parseEvent:[objects objectAtIndex:i]];
                [events addObject:e];
            }

            callback(ERROCODE_OK, events);

        } else {
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"error=%d, resp:%@", status, aStr);

            callback(ERROCODE_SERVER, nil);
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
            callback(ERROCODE_OK);
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
            callback(ERROCODE_OK);
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
            callback(ERROCODE_OK);
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
            callback(ERROCODE_OK);
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

            callback(ERROCODE_OK, buddies);
            
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
            callback(ERROCODE_OK);
        } else {
            callback(-1);
        }
    }];
}

-(void) createBuddy:(Buddy *) buddy andCallback:(void (^)(NSInteger error))callback
{
//TODO
}

-(EventModel *) getEventModel
{
    return eventModel;
}

+(Model *) getInstance
{
    if(instance == nil) {
        instance = [[Model alloc] init];
    }
    
    return instance;
}

@end
