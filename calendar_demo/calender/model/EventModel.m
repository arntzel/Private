
#import "EventModel.h"
#import "Event.h"
#import "Utils.h"

@interface DayEventsObject : NSObject

@property(strong)  NSString * day;
@property(strong)  NSMutableArray * allEvents;
@property int types;

-(id)initWithDay:(NSString *) pDay;

@end

@implementation DayEventsObject

-(id)initWithDay:(NSString *) pDay
{

    self = [super init];
    
    self.day = pDay;
    self.allEvents = [[NSMutableArray alloc] init];
    self.types = 0;
    
    return self;
}
@end



@implementation EventModel {

    NSArray * alldays;

    //Day -> DayEvents  
    NSMutableDictionary * dayEvents;
    
    //Month -> NSMutableArray
    NSMutableDictionary * monthEvents;
}

-(id) init {
    self = [super init];

    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
    monthEvents = [[NSMutableDictionary alloc] init];

    return self;
}

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month {

    //if([monthEvents objectForKey:month] == nil) {
        [monthEvents setObject:events forKey:month];

        for(int i=0;i<events.count;i++) {
            Event * event = [events objectAtIndex:i];

            NSString * day = [Utils formateDay:event.start];

            DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];
            
            if(dayEventsObj == nil) {
                dayEventsObj = [[DayEventsObject alloc] initWithDay:day];
                [dayEvents setObject:dayEventsObj forKey:day];
            }

            [dayEventsObj.allEvents addObject:event];
            
            int type = 0x00000001 << event.eventType;
            dayEventsObj.types |= type;
        }

        alldays = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * str1 = obj1;
            NSString * str2 = obj2;
            return [str2 compare:str1];
        }];
        
    //} else {
        //assert(NO);
    //}
}


-(NSArray *) getEventsByMonth:(NSString *) month {
    return [monthEvents objectForKey:month];
}

-(NSArray *) getEventsByDay:(NSString *) day {
    
    DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];

    if(dayEventsObj != nil) {
        return dayEventsObj.allEvents;
    } else {
        return nil;
    }
}

-(NSArray *) getAllDays {
    return alldays;
}

-(int) getEventsTypes:(NSString *) day
{
    DayEventsObject * obj = [dayEvents objectForKey:day];
    
    if(obj != nil) {
        return obj.types;
    } else {
        return 0;
    }
}

@end
