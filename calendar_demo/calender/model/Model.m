
#import "Model.h"
#import "Event.h"
#import "UserModel.h"
#import "Utils.h"
#import "NSDateAdditions.h"
#import "UserSetting.h"
#import <EventKit/EventKit.h>

#import "NSData+Hex.h"
#import "CoreDataModel.h"
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
        [self requestFailed:request];
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

    NSDictionary * dict = [evt convent2Dic];
     
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

-(void)getEventsFromCalendarApp:(void (^)(NSMutableArray * allEvents))callback
{
    EKEventStore *store = [[EKEventStore alloc] init];
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            if (granted)
            {
                
                NSLog(@"granted suc");
                // Get the appropriate calendar
                NSCalendar *calendar = [NSCalendar currentCalendar];
                
                // Create the start date components
                NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
                oneDayAgoComponents.month = -2;
                NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                              toDate:[NSDate date]
                                                             options:0];
                
                // Create the end date components
                NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
                oneYearFromNowComponents.month = 10;
                NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                                   toDate:[NSDate date]
                                                                  options:0];
                
                // Create the predicate from the event store's instance method
                NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                                        endDate:oneYearFromNow
                                                                      calendars:nil];
                
                // Fetch all events that match the predicate
                NSArray *events = [store eventsMatchingPredicate:predicate];
                NSMutableArray *_allEvents = [[NSMutableArray alloc] init];
                //NSLog(@"events:%@",events);
                for (EKEvent *event in events)
                {
                    Event *event1 = [[Event alloc] init];
                    event1.belongToiCal = event.calendar.calendarIdentifier;
                    event1.ext_event_id = event.eventIdentifier;
                    event1.eventType = 5;
                    event1.description = event.notes;
                    event1.is_all_day = event.isAllDay;
//                    if ([event.attendees count]>0)
//                    {
//                        NSMutableArray * invitees = [[NSMutableArray alloc] init];
//                        for(EKParticipant * user in event.attendees)
//                        {
//                            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
//                            ABRecordRef contactInfo = [user ABRecordWithAddressBook:addressBook];
//                            
//                            
//                            ABMutableMultiValueRef emailProperty = ABRecordCopyValue(contactInfo, kABPersonEmailProperty);
//                            if (ABMultiValueGetCount(emailProperty) > 0)
//                            {
//                                NSString *email = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emailProperty, 0));
//                                LOG_D(@"get email from Contacts App:%@",email);
//                                Invitee * invitee = [[Invitee alloc] init];
//                                invitee.email = email;
//                                [invitees addObject:invitee];
//                            }
//                            
//                        }
//                        
//                        event1.invitees = invitees;
//                    }
                    if (event.location)
                    {
                        Location *loc = [[Location alloc] init];
                        loc.location = event.location;
                        event1.location = loc;
                    }
                    event1.start = [Utils convertGMTDate:event.startDate andTimezone:event.timeZone];
                    LOG_D(@"event1.start:%@",event1.start);
                    event1.end = [Utils convertGMTDate:event.endDate andTimezone:event.timeZone];
                    LOG_D(@"event1.end:%@",event1.end);
                    event1.published = YES;
                    event1.timezone = event.timeZone.name;
                    event1.title = event.title;
                    event1.last_modified = [Utils convertGMTDate:event.lastModifiedDate andTimezone:event.timeZone];
                    event1.confirmed = YES;
                    LOG_D(@"event1.last_modified:%@",event1.last_modified);
                    [_allEvents addObject:event1];
                    
                    
                }
                
                callback(_allEvents);
            }
            else
            {
                NSLog(@"granted failed");
                callback(nil);
            }
        }];
    }
    else
    {
        callback(nil);
    }
   
}

- (void)uploadEventsFromCalendarApp:(NSMutableArray *)newEvents callback:(void (^)(NSInteger error, NSMutableArray * respEvents))callback
{
    for (int i = 0; i < [newEvents count]; i++)
    {
        FeedEventEntity *evt = [newEvents objectAtIndex:i];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *startTime = [format stringFromDate:evt.start];
        NSString *endTime = [format stringFromDate:evt.end];
        NSString *last_modified = [format stringFromDate:evt.last_modified];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary]; /*@{@"event_type": @(5)};*/
        [dic setObject:@(5) forKey:@"event_type"];
        [dic setObject:@(YES) forKey:@"confirmed"];
        if (evt.ext_event_id)
        {
            [dic setObject:evt.ext_event_id forKey:@"ext_event_id"];
        }
        if (last_modified)
        {
            [dic setObject:last_modified forKey:@"last_modified"];
        }
        if (evt.title)
        {
            [dic setObject:evt.title forKey:@"title"];
        }
        if (evt.is_all_day)
        {
            [dic setObject:evt.is_all_day forKey:@"is_all_day"];
        }
        if (evt.descript)
        {
            [dic setObject:evt.descript forKey:@"description"];
        }
        if (startTime)
        {
            [dic setObject:startTime forKey:@"start"];
        }
        if (endTime)
        {
            [dic setObject:endTime forKey:@"end"];
        }
        if (evt.timezone)
        {
            [dic setObject:evt.timezone forKey:@"timezone"];
        }
        if (evt.locationName)
        {
            [dic setObject:@{@"lat": @(0), @"lng":@(0),@"location":evt.locationName} forKey:@"location"];
        }
        [newEvents replaceObjectAtIndex:i withObject:dic];
    }
    NSDictionary  *postDataDic = @{@"objects": newEvents};
    NSString * postContent = [Utils dictionary2String:postDataDic];

    LOG_D(@"upload Calendar Event, postContent:%@", postContent);

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/", HOST];

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PATCH"];
    [[UserModel getInstance] setAuthHeader:request];

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {

        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;

        int status = httpResp.statusCode;

        if(status == 202 && error==nil)
        {

            if (!data)
            {
                callback(-1,nil);
                return ;
            }
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (error)
            {
                callback(-1,nil);
                return ;
            }
            LOG_D(@"upload Calendar Event resp:%@", json);
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[json objectForKey:@"objects"]];
            for (int i = 0; i<[arr count]; i++)
            {
                NSDictionary *dic = [arr objectAtIndex:i];
                Event * newEvent = [Event parseEvent:dic];
                [arr replaceObjectAtIndex:i withObject:newEvent];
            }
            callback(0,arr);
        }
        else
        {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"upload Calendar Event error=%@, resp:%@", error, aStr);
            callback(-1,nil);
          
        }
    }];

}
- (void)modifyICalEventWithEventEntity:(FeedEventEntity *)eventEntity callback:(void (^)(NSInteger error, Event * modifiedEvent))callback;
{
    LOG_D(@"updateEventsFromCalendarApp");
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, [eventEntity.id intValue]];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    [[UserModel getInstance] setAuthHeader:request];
    
    FeedEventEntity *evt = eventEntity;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *startTime = [format stringFromDate:evt.start];
    NSString *endTime = [format stringFromDate:evt.end];
    NSString *last_modified = [format stringFromDate:evt.last_modified];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary]; /*@{@"event_type": @(5)};*/
    [dic setObject:@(5) forKey:@"event_type"];
    [dic setObject:@(YES) forKey:@"confirmed"];
    [dic setObject:evt.ext_event_id forKey:@"ext_event_id"];
    if (last_modified)
    {
        [dic setObject:last_modified forKey:@"last_modified"];
    }
    if (evt.title)
    {
        [dic setObject:evt.title forKey:@"title"];
    }
    if (evt.is_all_day)
    {
        [dic setObject:evt.is_all_day forKey:@"is_all_day"];
    }
    if (evt.descript)
    {
        [dic setObject:evt.descript forKey:@"description"];
    }
    if (startTime)
    {
        [dic setObject:startTime forKey:@"start"];
    }
    if (endTime)
    {
        [dic setObject:endTime forKey:@"end"];
    }
    if (evt.timezone)
    {
        [dic setObject:evt.timezone forKey:@"timezone"];
    }
    if (evt.locationName)
    {
        [dic setObject:@{@"lat": @(0), @"lng":@(0),@"location":evt.locationName} forKey:@"location"];
    }
    NSString * postContent = [Utils dictionary2String:dic];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 202) {
            
            if (data)
            {//if data is nil, it will crash...
                NSError * err;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
                LOG_D(@"update Event resp:%@", json);
                
                if (error)
                {
                    callback(-1, nil);
                }
                else
                {
                    Event * newEvent = [Event parseEvent:json];
                    callback(0, newEvent);
                }
                
            }
            else
            {
                callback(-1, nil);
            }
           
            
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"createEvent error=%@, resp:%@", error, aStr);
            
            callback(-1, nil);
        }
    }];
    
}
- (void)deleteICalEventWithEventEntity:(FeedEventEntity *)eventEntity callback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, [eventEntity.id intValue]];
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"DELETE"];
    [[UserModel getInstance] setAuthHeader:request];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 204 || status == 404)
        {
            callback(0);
            
        }
        else
        {
            callback(-1);
        }
    }];
    
}
//-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
//    NSInteger iCurYear = [components year];  //当前的年份
//    NSInteger iCurMonth = [components month];  //当前的月份
//    [self getEvents:iCurYear andMonth:iCurMonth andCallback:callback];
//}


-(void) getEvent:(int) eventID andCallback:(void (^)(NSInteger error, Event * event))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];
    
    LOG_D(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
    
    [[UserModel getInstance] setAuthHeader:request];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            LOG_D(@"json=%@", json);

            Event * e = [Event parseEvent:json];
            callback(ERROCODE_OK, e);
            
        } else if(status == 404) {
            callback(ERROCODE_EVENT_NOTEXITED, nil);
        } else {
            
            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(ERROCODE_SERVER, nil);
        }
    }];
}

//-(void) getEvents:(int) year andMonth:(int) month andCallback:(void (^)(NSInteger error, NSArray* events))callback
//{
//       
//    NSString * startDay = [Utils formate:year andMonth:month];
//    
//    month++;
//    if(month>12) {
//        month = 1;
//        year ++;
//    }
//    
//    NSString * endDay = [Utils formate:year andMonth:month];
//    
//    startDay =[NSString stringWithFormat:@"%@-01T00:00:00", startDay];
//    endDay =[NSString stringWithFormat:@"%@-01T00:00:00", endDay];
//    
//    [self getEvents:startDay andEnd:endDay andCallback:callback];
//}

-(void) getEventsOfBegin:(NSDate *) begin andOffset:(int) offset andEventType:(NSString *) eventType andCallback:(void (^)(NSInteger error, NSInteger count, NSArray* events))callback
{
    
    NSString * startDay = [Utils formateDay:begin];
    startDay =[NSString stringWithFormat:@"%@T00:00:00", startDay];
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?limit=100&offset=%d&event_type__in=%@&start__gte=%@", HOST, offset, eventType, startDay];
    //NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?limit=20&offset=%d&start__gte=%@", HOST, offset, startDay];
    
    
    LOG_D(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    [self doGetEventsRequest:request andCallback:callback];    
}

-(void) getUpdatedEvents:(NSString *) modified_num andCallback:(void (^)(NSInteger error, NSInteger count, NSArray* events))callback;
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event?limit=40&offset=0&modified_num__gt=%@", HOST, modified_num];

    LOG_D(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];

    [self doGetEventsRequest:request andCallback:callback];
}

-(void) doGetEventsRequest:(NSMutableURLRequest *)request andCallback:(void (^)(NSInteger error, NSInteger count, NSArray* events))callback
{
    [[UserModel getInstance] setAuthHeader:request];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            int count = [[[json objectForKey:@"meta"] objectForKey:@"total_count"] intValue];
            LOG_D(@"Event resp:%@", json);

            NSArray * objects = [json objectForKey:@"objects"];

            NSMutableArray * events = [[NSMutableArray alloc] init];

            for(int i=0; i<objects.count;i++) {
                Event * e = [Event parseEvent:[objects objectAtIndex:i]];
                [events addObject:e];
            }

            callback(ERROCODE_OK, count, events);

        } else {

            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(ERROCODE_SERVER, 0, nil);
        }
    }];
}


//-(void) getEventsOfBegin:(NSDate *) begin andEnd:(NSDate*) end andCallback:(void (^)(NSInteger error, NSArray* events))callback
//{
//    NSString * startDay = [Utils formateDay:begin];
//    startDay =[NSString stringWithFormat:@"%@T00:00:00", startDay];
//
//
//    NSString * endDay = nil;
//    if(end != nil) {
//        endDay = [Utils formateDay:end];
//        endDay =[NSString stringWithFormat:@"%@T00:00:00", endDay];
//    }
//
//    [self getEvents:startDay andEnd:endDay andCallback:callback];
//}
//
//-(void) getEvents:(NSString *)startDay andEnd:(NSString *)endDay  andCallback:(void (^)(NSInteger error, NSArray* events))callback
//{
//    //start__gte=2013-06-15T00:00:00
//    //start__lt=2013-06-16T00:00:00
//
//    
//    NSString * url;
//    if(endDay == nil) {
//        url = [NSString stringWithFormat:@"%s/api/v1/event?limit=20&start__gte=%@", HOST, startDay];
//    } else {
//        url = [NSString stringWithFormat:@"%s/api/v1/event?limit=20&start__gte=%@&start__lt=%@", HOST, startDay, endDay];
//    }
//    
//    LOG_D(@"url=%@", url);
//    
//    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
//    
//    [self getEvents:request andCallback:callback];
//}
//
//-(void) getEventsOfDay:(NSDate *) day andCallback:(void (^)(NSInteger error, NSArray* events))callback
//{
//    NSDate * end = [day cc_dateByMovingToTheFollowingDayCout:1];
//    return [self getEventsOfBegin:day andEnd:end andCallback:callback];
//}

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


-(void) deleteEvent:(int) eventID andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];

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
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/message?read_at__isnull=true&limit=100", HOST];
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
            if (data)
            {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                
                NSArray * objects = [json objectForKey:@"objects"];
                
                NSMutableArray * events = [[NSMutableArray alloc] init];
                
                for(int i=0; i<objects.count;i++) {
                    Message * e = [Message parseMSeesage:[objects objectAtIndex:i]];
                    [events addObject:e];
                }
                
                callback(0, events);
            }
            else
            {
                callback(-1, nil);
            }
            
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


-(void) updateMessageReadStatus: (void (^)(NSInteger error))callback
{
    
}


-(void) getEventComment:(int) eventID Offset:(int)offset Limit:(int)limit andCallback:(void (^)(NSInteger error, NSArray * comments))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventcomment?event=%d&offset=%d&limit=%d", HOST, eventID,offset,limit];
    
    LOG_D(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"GET"];
    
    [[UserModel getInstance] setAuthHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 200 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            
            LOG_D(@"getEventComment resp:%@", json);

            NSArray * objects = [json objectForKey:@"objects"];
            
            NSMutableArray * cmts = [[NSMutableArray alloc] init];
            
            for(int i=0; i<objects.count;i++) {
                Comment * cmt = [Comment parseComment:[objects objectAtIndex:i]];
                [cmts addObject:cmt];
            }
            
            callback(ERROCODE_OK, [cmts sortedArrayUsingSelector:@selector(compare:)]);
            
        } else {
            
            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(-1, nil);
        }
    }];
}


-(void) createComment:(Comment *) cmt andCallback:(void (^)(NSInteger error, Comment * cmt))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventcomment/", HOST];
    
    LOG_D(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    [[UserModel getInstance] setAuthHeader:request];
    
    NSDictionary * dict = [cmt convent2Dic];
    NSString * postContent = [Utils dictionary2String:dict];
    
    LOG_D(@"createComment postContent=%@", postContent);
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
       
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        
        int status = httpResp.statusCode;
        
        if(status == 201) {
            
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            LOG_D(@"createComment resp:%@", json);
            
            Comment * newCmt = [Comment parseComment:json];
            callback(0, newCmt);
            
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"createComment error=%@, resp:%@", error, aStr);
            callback(-1, nil);
        }
    }];

}

-(void) createComment:(void (^)(NSInteger error, Comment * cmt))callback
{
    callback(0, nil);
}

-(void) updateVote:(EventTimeVote *) vote andproposeStartID:(int) proposeStartID andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventdatetimevote/%d", HOST, vote.id];
    
    LOG_D(@"url=%@", url);
    
    //NSMutableDictionary * jsonDic = [vote convent2Dic];
    
    NSMutableDictionary * jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setObject:@(vote.status) forKey:@"status"];
    
    NSString * eventTimeUrl = [NSString stringWithFormat:@"/api/v1/eventdatetime/%d", proposeStartID];
    [jsonDic setObject:eventTimeUrl forKey:@"event_datetime"];
    
    NSString * postContent = [Utils dictionary2String:jsonDic];
    
    LOG_D(@"postContent: %@", postContent);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    [[UserModel getInstance] setAuthHeader:request];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 202) {
            
            callback(ERROCODE_OK);
            
        } else {
            
            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(ERROCODE_SERVER);
        }
    }];
}

-(void) createVote:(int) proposeStartID andVoteStatus:(int) status andCallback:(void (^)(NSInteger error, int voteID))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventdatetimevote/", HOST];
    
    LOG_D(@"url=%@", url);
    
  
    
    NSMutableDictionary * jsonDic = [[NSMutableDictionary alloc] init];
    [jsonDic setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    
    NSString * eventTimeUrl = [NSString stringWithFormat:@"/api/v1/eventdatetime/%d", proposeStartID];
    [jsonDic setObject:eventTimeUrl forKey:@"event_datetime"];
    
    
    NSString * postContent = [Utils dictionary2String:jsonDic];
    

    LOG_D(@"postContent: %@", postContent);
    
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
            
            NSLog(@"createVote:%@", json);
            int voteID = [[json objectForKey:@"id"] intValue];
            callback(ERROCODE_OK, voteID);
            
        } else {
            
            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }
            
            callback(ERROCODE_SERVER, 0);
        }
    }];
}

-(void) createProposeStart:(Event *) event andPropose:(ProposeStart *) proposeStat andCallback:(void (^)(NSInteger error, ProposeStart * proposeStat))callback
{

    /*
     start: date time(UTC), format: YYYY-MM-DDTHH24:MI:SS
     start_type: choice from "exactly_at", "within_an_hour", "anytime_after"
     event: the event resource uri, for example: /api/v1/event/6161
     contact: the contact resource uri, for example: /api/v1/contact/17, this field means who create the date time. You can get the contact uri from event api.
     is_all_day: optional, true or false
     duration_days: optional, if the is_all_day is true, this value should be >=1
     duration_hours: optional, if the is_all_day is false, this value can be >=1 and <24
     duration_minutes: optional, if the is_all_day is false, can be >=0
     */
    
    
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventdatetime/", HOST];

    LOG_D(@"url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"POST"];
    [[UserModel getInstance] setAuthHeader:request];

    NSDictionary * dict = [proposeStat convent2Dic];
    
    NSMutableDictionary * jsonDic =  [NSMutableDictionary dictionaryWithDictionary:dict];
    NSString * eventUri = [NSString stringWithFormat:@"/api/v1/event/%d", event.id];
    [jsonDic setObject:eventUri forKey:@"event"];

    User * me = [[UserModel getInstance] getLoginUser];
    EventAttendee * atd = [[event getAttendeesDic] objectForKey:me.email];
    int contactID = atd.contact.id;

    NSString * contactUri = [NSString stringWithFormat:@"/api/v1/contact/%d", contactID];
    [jsonDic setObject:contactUri forKey:@"contact"];
    //[jsonDic removeObjectForKey:@"vote"];
    
    NSString * postContent = [Utils dictionary2String:jsonDic];


    LOG_D(@"postContent: %@", postContent);

    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 201 && data != nil) {
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

            LOG_D(@"RESP: %@", json);

            int pId = [[json objectForKey:@"id"] intValue];
            proposeStat.id = pId;

            EventTimeVote * vote = [[EventTimeVote alloc] init];
            vote.email = [[UserModel getInstance] getLoginUser].email;
            vote.status = 1;

            proposeStat.votes = [NSMutableArray arrayWithObject:vote];

            callback(ERROCODE_OK, proposeStat);

        } else {

            if(data != nil) {
                NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                LOG_D(@"error=%d, resp:%@", status, aStr);
            }

            callback(ERROCODE_SERVER, nil);
        }
    }];
}

-(void) deleteProposeStart:(int) proposeStatID andCallback:(void (^)(NSInteger error))callback
{
    
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventdatetime/%d", HOST, proposeStatID];
    
    LOG_D(@"url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"DELETE"];
    [[UserModel getInstance] setAuthHeader:request];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 204) {
            
            callback(ERROCODE_OK);
            
        } else {
            callback(ERROCODE_SERVER);
        }
    }];
}

-(void) finalizeProposeStart:(int) eventID ProposeStart:(ProposeStart *) proposeStart andCallback:(void (^)(NSInteger error, Event * event))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];

    LOG_D(@"url=%@", url);


    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];

    //{"body": "Hey~Hey", "email": "user1@pencilme.com", "sent_at": "2012-12-12T12:12:12", "subject": "new subject"}

    NSDictionary * proposeStartDic = [proposeStart convent2Dic];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:proposeStartDic];
    [dict removeObjectForKey:@"id"];
    [dict removeObjectForKey:@"vote"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"confirmed"];
    
    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];

    LOG_D(@"finalizeProposeStart: %@", postContent);

    [request setHTTPBody:postData];

    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 202) {

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


-(void) updateLocation:(int) eventID Location:(Location *) location andCallback:(void (^)(NSInteger error))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];
    
    LOG_D(@"updateLocation url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    
    NSDictionary * loctionDic = [location convent2Dic];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:loctionDic forKey:@"location"];
    
    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    LOG_D(@"updateLocation: %@", postContent);
    
    [request setHTTPBody:postData];
    
    [[UserModel getInstance] setAuthHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 202) {
            
            callback(ERROCODE_OK);
            
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"createEvent error=%@, resp:%@", error, aStr);
            
            callback(ERROCODE_NETWORK);
        }
        
    }];
}


-(void) updateEventAttendeeStatus:(int) atdID andInviteeKey:(NSString *) invite_key  andStatus:(int) status andCallback:(void (^)(NSInteger error))callback;
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/eventattendee/%d", HOST, atdID];
    
    LOG_D(@"updateLocation url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:invite_key forKey:@"invite_key"];
    [dict setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    
    NSString * postContent =  [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    LOG_D(@"updateEventAttendeeStatus: %@", postContent);
    
    [request setHTTPBody:postData];
    
    [[UserModel getInstance] setAuthHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 202) {
            
            callback(ERROCODE_OK);
            
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"createEvent error=%@, resp:%@", error, aStr);
            
            callback(ERROCODE_NETWORK);
        }
        
    }];

}

-(void) updateEventPhoto:(int) eventID PhotoUrl:(NSString *) photourl andCallback:(void (^)(NSInteger error))callback
{

    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];

    LOG_D(@"updateLocation url=%@", url);

    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];


    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:photourl forKey:@"thumbnail_url"];
    NSString * postContent = [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];

    LOG_D(@"updateEventPhoto: %@", postContent);

    [request setHTTPBody:postData];
    [[UserModel getInstance] setAuthHeader:request];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;

        if(status == 202) {

            callback(ERROCODE_OK);

        } else {

            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"updateEventPhoto error=%@, resp:%@", error, aStr);

            callback(ERROCODE_NETWORK);
        }
    }];
}

-(void) inviteContacts:(int) eventID andContact:(NSArray *) invitees andCallback:(void (^)(NSInteger error, Event * newEvent))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/%d", HOST, eventID];
    
    LOG_D(@"inviteContacts url=%@", url);
    
    NSMutableURLRequest *request = [Utils createHttpRequest:url andMethod:@"PUT"];
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSMutableArray * jsonarray = [[NSMutableArray alloc] init];
    
    for(Invitee * invitee in invitees) {
        [jsonarray addObject:[invitee convent2Dic]];
    }
    
    [dict setObject:jsonarray forKey:@"invitees"];
    
    NSString * postContent =  [Utils dictionary2String:dict];
    NSData * postData = [postContent dataUsingEncoding:NSUTF8StringEncoding];
    
    LOG_D(@"inviteContacts postContent: %@", postContent);
    
    [request setHTTPBody:postData];
    
    [[UserModel getInstance] setAuthHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
        if(status == 202) {
            
            NSError * err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            LOG_D(@"inviteContacts resp:%@", json);
            
            Event * newEvent = [Event parseEvent:json];
            callback(0, newEvent);
            
        } else {
            
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            LOG_D(@"inviteContacts error=%@, resp:%@", error, aStr);
            
            callback(-1, nil);
        }
    }];
}
@end
