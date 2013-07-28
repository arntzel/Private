
#import "EventModel.h"
#import "Event.h"
#import "Utils.h"

@interface DayEventsObject : NSObject

@property(strong)  NSString * day;
@property int types;

-(id)initWithDay:(NSString *) pDay;

-(void) setFilter:(int) filter;

-(void) addEvent:(Event*) event;

-(NSArray *) getEventsByFilter;

@end


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

    NSMutableArray * delegates;
}

-(id) init {
    self = [super init];

    _filter = 0;

    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];

    delegates = [[NSMutableArray alloc] init];

    return self;
}

-(void) addDelegate:(id<EventModelDelegate>) delegate
{
    [delegates addObject:delegate];
}

-(void) removeDelegate:(id<EventModelDelegate>) delegate
{
    [delegates removeObject:delegate];
}

-(void) nofityModelChanged
{
    for(id<EventModelDelegate> delegate in delegates) {
        [delegate onEventModelChanged];
    }
}

-(void) clear
{
    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];

    [self nofityModelChanged];
}


-(void) addEvents:(NSArray *) eveents
{
    for(Event * ev in eveents) {
        [self addEvent:ev];
    }

    [self rebuildDaysArray];

    [self nofityModelChanged];
}

-(void) addNewEvent:(Event*) newEvent
{
    [self addEvent:newEvent];

    [self rebuildDaysArray];

    [self nofityModelChanged];
}

-(void) addEvent:(Event*) event
{
    NSString * day = [Utils formateDay: event.start];

    DayEventsObject * dayObj = [dayEvents objectForKey:day];

    if(dayObj == nil) {
        dayObj = [[DayEventsObject alloc] initWithDay:day];
        [dayObj setFilter:_filter];
        [dayEvents setObject:dayObj forKey:day];
        [alldays addObject:day];
    }

    [dayObj addEvent:event];
}

-(int) getFilter
{
    return _filter;
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

    [self nofityModelChanged];
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

-(NSArray *) getEventsByBeginDay:(NSDate *) start andEndDay:(NSDate *) end
{

    NSString * strStart = [Utils formateDay:start];
    NSString * strEnd = [Utils formateDay:end];


    NSMutableArray * array = [[NSMutableArray alloc] init];

    
    NSArray * allDays = [self getAllDays];

    for(NSString * day in allDays) {

        if( [day compare:strStart] >=0 && [day compare:strEnd] <0) {
            NSArray * events = [self getEventsByDay:day];
            [array addObjectsFromArray:events];
        }
    }

    return array;
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
