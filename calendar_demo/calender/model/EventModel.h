

#import <Foundation/Foundation.h>
#import "Event.h"

#import "NSDateAdditions.h"

@interface DayEventsObject : NSObject

@property(strong)  NSString * day;
@property int types;

-(id)initWithDay:(NSString *) pDay;

-(void) setFilter:(int) filter;

-(void) addEvent:(Event*) event;

-(NSArray *) getEventsByFilter;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject

@property(strong) NSDate * begin;
@property(strong) NSDate * end;


-(void) clear;

-(void) addEvents:(NSArray *) eveent;

-(void) addNewEvent:(Event*) newEvent;

-(void) setFilter:(int) filter;



-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;

-(int) getEventsTypes:(NSString *) day;

@end
