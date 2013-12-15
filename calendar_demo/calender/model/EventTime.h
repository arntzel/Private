
#import <Foundation/Foundation.h>
#import "EventTimeVote.h"

@interface EventTime : NSObject

@property int id;

@property(strong) NSDate * startTime;
@property(strong) NSDate * endTime;

/**
 0: not yet
 1: finalized
 2: decline
 */
@property int finalized;

//EventTimeVote list
@property(strong) NSArray * votes;

@end
