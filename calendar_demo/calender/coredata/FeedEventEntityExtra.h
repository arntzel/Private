

#import <Foundation/Foundation.h>
#import "FeedEventEntity.h"
#import "UserEntity.h"
#import "Event.h"

@interface FeedEventEntity (FeedEventEntityExtra)


-(NSDate*) getLocalStart;


-(BOOL) isBirthdayEvent;

-(BOOL) isCalvinEvent;

-(BOOL) isHistory;

-(void) convertFromEvent:(Event*) event;
-(void) convertFromCalendarEvent:(Event*) event;

-(void) parserFromJsonData:(NSDictionary *) jsonData;


@end
