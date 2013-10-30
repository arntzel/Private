

#import <Foundation/Foundation.h>
#import "FeedEventEntity.h"
#import "UserEntity.h"
#import "Event.h"

@interface FeedEventEntity (FeedEventEntityExtra)

-(void)clearAttendee;

-(NSDate*) getLocalStart;

-(UserEntity*) getCreator;


-(BOOL) isAllAttendeeResped;

-(BOOL) isBirthdayEvent;

-(BOOL) isCalvinEvent;

-(BOOL) isHistory;

-(void) convertFromEvent:(Event*) event;
-(void) convertFromCalendarEvent:(Event*) event;

@end
