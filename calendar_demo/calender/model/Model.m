
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

+(Model *) getInstance
{
    if(instance == nil) {
        instance = [[Model alloc] init];
    }
    
    return instance;
}

@end
