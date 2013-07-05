

#import <Foundation/Foundation.h>
#import "Event.h"


@interface DayEventsObject : NSObject

@property(strong)  NSString * day;
@property(strong)  NSMutableArray * allEvents;
@property int types;

-(id)initWithDay:(NSString *) pDay;

-(void) addEvent:(Event*) event;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MonthEventsObject : NSObject

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month;

-(NSArray *) getEvents;

-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;

-(NSString *) getMonth;

-(void) clear;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject


-(void) clear;

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month;


-(NSArray *) getEventsByMonth:(NSString *) month;

-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;

/*
 
 */
-(int) getEventsTypes:(NSString *) day;

@end
