
#import "Model.h"
#import "Event.h"
#import "UserModel.h"
#import "Utils.h"
#import "NSDateAdditions.h"

static Model * instance;

@interface ASIHTTPRequestDelegateAdapter : NSObject <ASIHTTPRequestDelegate>

@property(nonatomic, strong) id<UploadImageDelegate> delegate;

@end


@implementation ASIHTTPRequestDelegateAdapter

- (void)requestStarted:(ASIHTTPRequest *)request
{
    [self.delegate onUploadStart];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    int httpRespCode = [request responseStatusCode];
    LOG_D(@"uploadFinished: code=%d, msg=%@" , httpRespCode, [request responseStatusMessage]);
    
    if(httpRespCode == 200) {
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];

        NSString * imgUrl = [json valueForKey:@"thumbnail_url"];
        [self.delegate onUploadCompleted:0 andUrl:imgUrl];
        
    } else {
        [self requestFinished:request];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.delegate onUploadCompleted:-1 andUrl:nil];
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    LOG_D(@"didSendBytes:%lld / %lld", request.totalBytesSent, request.postLength);
    [self.delegate onUploadProgress:request.totalBytesSent andSize:request.postLength];
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Model  {
    EventModel * eventModel;
    MessageModel * msgModel;
    
    ASIHTTPRequestDelegateAdapter * uploadImgDelegateAdapter;
}

-(id) init {
    self = [super init];
    eventModel = [[EventModel alloc] init];
    msgModel = [[MessageModel alloc] init];
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


    if(evt.attendees != nil) {
        NSMutableArray * invitees =  [[NSMutableArray alloc] init];

        for(int i=0; i<evt.attendees.count; i++) {
            EventAttendee * atd = [evt.attendees objectAtIndex:i];

            NSMutableDictionary * userDic = [[NSMutableDictionary alloc] init];
            [userDic setObject:atd.user.email forKey:@"email"];
            [userDic setObject:atd.user.username forKey:@"username"];

            [invitees addObject:userDic];
        }
        
        [dict setObject:invitees forKey:@"invitees"];
    }

    if(evt.location != nil) {
        NSMutableDictionary * location =  [[NSMutableDictionary alloc] init];
        [location setObject:evt.location.location forKey:@"location"];
        [location setObject:[NSNumber numberWithFloat:evt.location.lat]  forKey:@"lat"];
        [location setObject:[NSNumber numberWithFloat:evt.location.lng]  forKey:@"lng"];
        [dict setObject:location forKey:@"location"];
    }

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

    LOG_D(@"createEvent, postContent:%@", postContent);

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
            LOG_D(@"createEvent resp:%@", json);

            Event * newEvent = [Event parseEvent:json];
            callback(0, newEvent);
            
        } else {

            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"createEvent error=%@, resp:%@", error, aStr);

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

-(void) getEventsOfBegin:(NSDate *) begin andEnd:(NSDate*) end andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
    NSString * startDay = [Utils formateDay:begin];
    startDay =[NSString stringWithFormat:@"%@T00:00:00", startDay];


    NSString * endDay = nil;
    if(end != nil) {
        endDay = [Utils formateDay:end];
        endDay =[NSString stringWithFormat:@"%@T00:00:00", endDay];
    }

    [self getEvents:startDay andEnd:endDay andCallback:callback];
}

-(void) getEvents:(NSString *)startDay andEnd:(NSString *)endDay  andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
    //start__gte=2013-06-15T00:00:00
    //start__lt=2013-06-16T00:00:00

    
    NSString * url;
    if(endDay == nil) {
        url = [NSString stringWithFormat:@"%s/api/v1/event?limit=0&start__gte=%@", HOST, startDay];
    } else {
        url = [NSString stringWithFormat:@"%s/api/v1/event?limit=0&start__gte=%@&start__lt=%@", HOST, startDay, endDay];
    }
    
    LOG_D(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
    
    [self getEvents:request andCallback:callback];
}

-(void) getEventsOfDay:(NSDate *) day andCallback:(void (^)(NSInteger error, NSArray* events))callback
{
    NSDate * end = [day cc_dateByMovingToTheFollowingDayCout:1];
    return [self getEventsOfBegin:day andEnd:end andCallback:callback];
}

-(void) getEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback
{
    NSString * currentDate = [Utils formateDay: [NSDate date]];
    //User * me = [[UserModel getInstance] getLoginUser];
    //NSString  * encodedName = [me.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&creator=%@", HOST, currentDate, encodedName];
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&event_type=0", HOST, currentDate];

    LOG_D(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    [self getEvents:request andCallback:callback];
}

-(void) getRelativeEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback
{
    
    NSString * currentDate = [Utils formateDay: [NSDate date]];
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?end__gte=%@T00:00:00&attendee_status=PENDING", HOST, currentDate];
    
    LOG_D(@"url=%@", url);
    
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

        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            //LOG_D(@"Event resp:%@", json);

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * events = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Event * e = [Event parseEvent:[objects objectAtIndex:i]];
                [events addObject:e];
            }

            callback(ERROCODE_OK, events);

        } else {
            
            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(ERROCODE_SERVER, nil);
        }
    }];

}


-(void) updateEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, event.id];

    LOG_D(@"url=%@", url);


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

    LOG_D(@"url=%@", url);

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


-(void) getUnreadMessages:(void (^)(NSInteger error, NSArray* messages))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message?read_at__isnull=true", HOST];
    LOG_D(@"url=%@", url);
    [self doGetMessage:url andCallback:callback];
}

-(void) readMessage:(int) msgID andCallback:(void (^)(NSInteger error, int msgID))callback
{
    //PUT /api/v1/message/1/ {"read_at":now()}
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message/%d", HOST, msgID];
    
    LOG_D(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    
    NSString * now = [Utils formateDate: [NSDate date]];
    NSString * postContent =  [NSString stringWithFormat:@"{\"read_at\":\"%@\"}", now];
    
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    [[UserModel getInstance] setAuthHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 202) {
            callback(ERROCODE_OK, msgID);
        } else {
            callback(-1, msgID);
        }
    }];

}

-(void) readAllMessage: (void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s//api/v1/readall/message/", HOST];
    LOG_D(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        if(callback == nil) return;

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 200) {
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

    LOG_D(@"url=%@", url);

    [self doGetMessage:url andCallback:callback];
}


-(void) getMessages:(int) offset andCallback :(void (^)(NSInteger error, NSArray* messages))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message?offset=%d", HOST, offset];

    LOG_D(@"url=%@", url);

    [self doGetMessage:url andCallback:callback];
}

-(void) doGetMessage:(NSString *) url andCallback:(void (^)(NSInteger error, NSArray* messages))callback
{
    
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

    LOG_D(@"url=%@", url);


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

    LOG_D(@"url=%@", url);

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

    LOG_D(@"url=%@", url);


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

    LOG_D(@"url=%@", url);

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


-(ASIFormDataRequest *) uploadImage:(UIImage *) img andCallback:(id<UploadImageDelegate>)delegate;
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/photo/upload/", HOST];

    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    
    User * currentUser = [[UserModel getInstance] getLoginUser];
    
    NSString * authHeader = [NSString stringWithFormat:@"ApiKey %@:%@", currentUser.username, currentUser.apikey];
    [request addRequestHeader:@"Authorization" value:authHeader];
    
	NSData *data = UIImageJPEGRepresentation(img, 1.0);
    [request setData:data withFileName:@"img.jpg" andContentType:@"image/jpeg" forKey:@"file"];
    
      
    [request setRequestMethod:@"POST"];
	[request setTimeOutSeconds:40];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
    
	    
    uploadImgDelegateAdapter = [[ASIHTTPRequestDelegateAdapter alloc] init];
    uploadImgDelegateAdapter.delegate = delegate;
    
    [request setUploadProgressDelegate:uploadImgDelegateAdapter];
	[request setDelegate:uploadImgDelegateAdapter];
	
    [request startAsynchronous];
    
    return  request;
}

-(EventModel *) getEventModel
{
    return eventModel;
}

-(MessageModel *) getMessageModel
{
    return msgModel;
}

+(Model *) getInstance
{
    if(instance == nil) {
        instance = [[Model alloc] init];
    }
    
    return instance;
}

@end
