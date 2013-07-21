

#import <Foundation/Foundation.h>
#import "Event.h"


@protocol EventModelDelegate <NSObject>

-(void) onEventModelChanged;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EventModel : NSObject

@property(strong) NSDate * begin;
@property(strong) NSDate * end;


-(void) addDelegate:(id<EventModelDelegate>) delegate;

-(void) removeDelegate:(id<EventModelDelegate>) delegate;


-(void) clear;

-(void) addEvents:(NSArray *) eveent;

-(void) addNewEvent:(Event*) newEvent;

-(void) setFilter:(int) filter;



-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;

-(int) getEventsTypes:(NSString *) day;

@end
