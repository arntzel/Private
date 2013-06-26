

#import <Foundation/Foundation.h>

@interface EventModel : NSObject


-(void) setEvents:(NSArray *) events forMonth:(NSString*) month;


-(NSArray *) getEventsByMonth:(NSString *) month;

-(NSArray *) getEventsByDay:(NSString *) day;

-(NSArray *) getAllDays;

/*
 
 */
-(int) getEventsTypes:(NSString *) day;

@end
