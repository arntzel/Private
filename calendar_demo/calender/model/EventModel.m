
#import "EventModel.h"
#import "Event.h"
#import "Utils.h"

@implementation DayEventsObject {
    
    NSMutableArray * allEvents;
    NSMutableArray * filterEvents;
    int _filter;
}

-(id)initWithDay:(NSString *) pDay
{

    self = [super init];
    
    self.day = pDay;
    self.types = 0;

    _filter  = 0;
    allEvents = [[NSMutableArray alloc] init];
    filterEvents = [[NSMutableArray alloc] init];
    
    return self;
}

-(void) setFilter:(int) filter
{
    _filter = filter;
    [self resetFilterEvents];
}

-(void) addEvent:(Event*) event
{
    //Filter duplicated event obj
    for(int i=0; i<allEvents.count; i++) {
        Event * oldEvt = [allEvents objectAtIndex:i];
        if(event.id == oldEvt.id) {
            [allEvents  replaceObjectAtIndex:i withObject:event];
            [self resetFilterEvents];
            return;
        }
    }

    int type = 0x00000001 << event.eventType;
    self.types |= type;
    
    [allEvents addObject:event];

    NSArray * sortedArray = [allEvents sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Event * evt1 = obj1;
        Event * evt2 = obj2;
        return [evt2.start compare:evt1.start];
    }];

    allEvents = [[NSMutableArray alloc] initWithArray:sortedArray];

    [self resetFilterEvents];
}

-(void) resetFilterEvents
{
    [filterEvents removeAllObjects];

    for(int i=0; i<allEvents.count; i++) {
        Event * evt = [allEvents objectAtIndex:i];

        int type = 0x00000001 << evt.eventType;

        if( (type & _filter) > 0) {
            [filterEvents addObject:evt];
        }
    }
}

-(NSArray *) getEventsByFilter
{
    return filterEvents;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventModel {

    int _filter;
    
    NSMutableArray * alldays;

    //Day -> DayEvents  
    NSMutableDictionary * dayEvents;

}

-(id) init {
    self = [super init];

    _filter = 0;

    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void) clear
{
    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
}


-(void) addEvents:(NSArray *) eveents
{
    for(Event * ev in eveents) {
        [self addEvent:ev];
    }

    [self rebuildDaysArray];
}

-(void) addNewEvent:(Event*) newEvent
{
    [self addNewEvent:newEvent];

    [self rebuildDaysArray];
}

-(void) addEvent:(Event*) newEvent
{
    NSString * day = [Utils formateDay: newEvent.start];

    DayEventsObject * dayObj = [dayEvents objectForKey:day];

    if(dayObj == nil) {
        dayObj = [[DayEventsObject alloc] initWithDay:day];
        [dayObj setFilter:_filter];
        [dayEvents setObject:dayObj forKey:day];
        [alldays addObject:day];
    }

    [dayObj addEvent:newEvent];
}

-(void) setFilter:(int) filter
{
    _filter = filter;

    NSArray * days = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str1 compare:str2];
    }];

    [alldays removeAllObjects];

    for(NSString * day  in days) {
        DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];
        [dayEventsObj setFilter:_filter];

        if([dayEventsObj getEventsByFilter].count > 0) {
            [alldays addObject:day];
        }
    }
}

-(void) rebuildDaysArray
{
    NSArray * days = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str1 compare:str2];
    }];

    
    [alldays removeAllObjects];

    for(NSString * day  in days) {
        DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];
        if([dayEventsObj getEventsByFilter].count > 0) {
            [alldays addObject:day];
        }
    }
}

-(NSArray *) getEventsByDay:(NSString *) day {
    
    DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];

    if(dayEventsObj != nil) {

        return [dayEventsObj getEventsByFilter];
        
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
