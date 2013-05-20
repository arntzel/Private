
#import "Model.h"
#import "Event.h"


static Model * instance;

@implementation Model


-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback
{
    NSString * url = [NSString stringWithFormat:@"%s/api/v1/event/?format=json", HOST];
    
    NSLog(@"url=%@", url);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
        NSHTTPURLResponse * httpResp = (NSHTTPURLResponse*) resp;
        int status = httpResp.statusCode;
        
//        if(status == 200) {
//            NSError * err;
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
//        
//            //TODO:: parse the json data 
//            
//            callback(0, nil);
//
//        } else {
//            callback(-1, nil);
//        }

        //Mock up
        NSArray * events = [self createMockupEvents];
        callback(0, events);
    }];

    
}

-(NSArray *) createMockupEvents {

    NSMutableArray * array = [[NSMutableArray alloc] init];

    Location * location = [[Location alloc] init];
    location.locationName = @"No location determined";
    User * host = [[User alloc] init];
    host.username = @"User name";

    for(int i = 0;i<5;i++) {

        NSDate * createTime = [NSDate dateWithTimeIntervalSinceNow:i*3600*24];

        Event * event = [[Event alloc] init];
        event.eventTitle = @"Dinner with roommates";
        event.eventType  = 0;
        event.host = host;
        event.location = location;
        event.attenedees = @"153 attendees";
        event.startTime = createTime;
        event.duration = 2*2600;
        
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
