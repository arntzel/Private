

#import <Foundation/Foundation.h>
#import "Event.h"

#import "NSDateAdditions.h"

@interface DayEventsObject : NSObject

@property(strong)  NSString * day;
@property(strong)  NSMutableArray * allEvents;
@property int types;

-(id)initWithDay:(NSString *) pDay;

-(void) addEvent:(Event*) event;

-(NSArray *) getEventsByFilter:(int) filter;

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
