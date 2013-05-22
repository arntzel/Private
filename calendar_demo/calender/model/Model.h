
#import <Foundation/Foundation.h>
#import "User.h"


@interface Model : NSObject





/**
 Call WebService API to get the lastest events.s
 */
-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;

+(Model *) getInstance;


@end
