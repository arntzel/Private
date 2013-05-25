
#import <Foundation/Foundation.h>
#import "User.h"
#import "Event.h"

@interface Model : NSObject





/**
 Call WebService API to get the lastest events.s
 */
-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;


/**
 Update event title and description
 */
-(void) updateEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback;

/**
 Delete a event
 */
-(void) deleteEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback;


+(Model *) getInstance;


@end
