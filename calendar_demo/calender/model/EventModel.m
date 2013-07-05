
#import "EventModel.h"
#import "Event.h"
#import "Utils.h"

@implementation DayEventsObject

-(id)initWithDay:(NSString *) pDay
{

    self = [super init];
    
    self.day = pDay;
    self.allEvents = [[NSMutableArray alloc] init];
    self.types = 0;
    
    return self;
}

-(void) addEvent:(Event*) event
{
    //Filter duplicated event obj
    for(int i=0; i<self.allEvents.count; i++) {
        Event * oldEvt = [self.allEvents objectAtIndex:i];
        if(event.id == oldEvt.id) {
            [self.allEvents  replaceObjectAtIndex:i withObject:event];
            return;
        }
    }
    
    [self.allEvents addObject:event];
}
@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MonthEventsObject {
    
    NSArray * _events;
    NSString * _month;

    NSArray * _alldays;

    //Day -> DayEvents
    NSMutableDictionary * _dayEvents;
}

-(id) init
{
    self = [super init];

    _alldays = [[NSMutableArray alloc] init];
    _dayEvents = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void) clear
{
    _events = nil;
    _month = nil;
    _alldays = nil;
    [_dayEvents removeAllObjects];
}

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month
{
    _events = events;
    _month = month;

    for(int i=0;i<events.count;i++) {
        Event * event = [events objectAtIndex:i];

        NSString * day = [Utils formateDay:event.start];

        DayEventsObject * dayEventsObj = [_dayEvents objectForKey:day];
        if(dayEventsObj == nil) {
            dayEventsObj = [[DayEventsObject alloc] initWithDay:day];
            [_dayEvents setObject:dayEventsObj forKey:day];
        }

        [dayEventsObj addEvent:event];

        int type = 0x00000001 << event.eventType;
        dayEventsObj.types |= type;
    }

    _alldays = [[_dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str2 compare:str1];
    }];

}

-(NSArray *) getEvents{
    return _events;
}

-(NSString *) getMonth{
    return  _month;
}

-(NSArray *) getEventsByDay:(NSString *) day
{
    DayEventsObject * dayEventsObj = [_dayEvents objectForKey:day];
    return dayEventsObj.allEvents;
}

-(NSArray *) getAllDays
{
    return _alldays;
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////
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

-(void) clear
{
    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
    monthEvents = [[NSMutableDictionary alloc] init];
}

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month {

    [monthEvents setObject:events forKey:month];
    
    for(int i=0;i<events.count;i++) {
        Event * event = [events objectAtIndex:i];
        
        NSString * day = [Utils formateDay:event.start];
        
        DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];
        if(dayEventsObj == nil) {
            dayEventsObj = [[DayEventsObject alloc] initWithDay:day];
            [dayEvents setObject:dayEventsObj forKey:day];
        }
        
        [dayEventsObj addEvent:event];
        
        int type = 0x00000001 << event.eventType;
        dayEventsObj.types |= type;
    }
    
    alldays = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str2 compare:str1];
    }];
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
