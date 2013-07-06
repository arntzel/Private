
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

    int type = 0x00000001 << event.eventType;
    self.types |= type;
    
    [self.allEvents addObject:event];
}

-(NSArray *) getEventsByFilter:(int) filter
{
    NSMutableArray * events = [[NSMutableArray alloc] init];
    
    for(int i=0; i<self.allEvents.count; i++) {
        Event * evt = [self.allEvents objectAtIndex:i];

        int type = 0x00000001 << evt.eventType;

        if( (type & filter) > 0) {
            [events addObject:evt];
        }
    }

    return events;
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

    }

    _alldays = [[_dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str2 compare:str1];
    }];

}

-(void) setFilter:(int) filter
{

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

-(DayEventsObject *) getDayEventsObjectByDay:(NSString *) day
{
    return [_dayEvents objectForKey:day];
}

-(NSArray *) getAllDays
{
    return _alldays;
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventModel {

    //Only save the three months data
    NSMutableArray * _monthEventsObjects;
    int _filter;
    
    NSArray * alldays;

    //Day -> DayEvents  
    NSMutableDictionary * dayEvents;
    
    //Month -> MonthEventsObject
    NSMutableDictionary * monthEvents;    
}

-(id) init {
    self = [super init];

    _monthEventsObjects = [[NSMutableArray alloc] init];
    _filter = 0;

    
    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
    monthEvents = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void) clear
{
    [_monthEventsObjects removeAllObjects];
    
    alldays = [[NSMutableArray alloc] init];
    dayEvents = [[NSMutableDictionary alloc] init];
    monthEvents = [[NSMutableDictionary alloc] init];
}

-(void) setEvents:(NSArray *) events forMonth:(NSString*) month {

    NSLog(@"EventModel: setEvents: %@: count=%d", month, events.count);

    if(_monthEventsObjects.count>=3) {
        //TODO:: Xiang Fang
        //[_monthEventsObjects removeObjectAtIndex:0];
    }

    MonthEventsObject * monthEventsObj = [[MonthEventsObject alloc] init];
    [monthEventsObj setEvents:events forMonth:month];

    [_monthEventsObjects  addObject:monthEventsObj];

    [self rebuild];
}

-(void) setFilter:(int) filter
{
    _filter = filter;
    
}

-(void) rebuild
{

    dayEvents = [[NSMutableDictionary alloc] init];
    monthEvents = [[NSMutableDictionary alloc] init];

    for(int i=0 ;i<_monthEventsObjects.count;i++) {

        MonthEventsObject * monthEventsObj = [_monthEventsObjects objectAtIndex:i];

        [monthEvents setObject:monthEventsObj forKey:[monthEventsObj getMonth]];

        NSArray * monthdays = [monthEventsObj getAllDays];

        for(int j=0;j<monthdays.count;j++) {
            
            NSString * day = [monthdays objectAtIndex:j];

            DayEventsObject * dayObj = [monthEventsObj getDayEventsObjectByDay:day];

            if (_filter==0 || (dayObj.types & _filter) > 0) {
                
                [dayEvents setObject:dayObj forKey:day];
            } 
        }
    }

    alldays = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str2 compare:str1];
    }];
}

-(MonthEventsObject *) getEventsByMonth:(NSString *) month {
    return [monthEvents objectForKey:month];
}

-(NSArray *) getEventsByDay:(NSString *) day {
    
    DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];

    if(dayEventsObj != nil) {


        if(_filter==0) {
            return dayEventsObj.allEvents;
        }


        NSMutableArray * events = [[NSMutableArray alloc] init];

        for(int i=0;i<dayEventsObj.allEvents.count;i++) {
            
            Event * evt = [dayEventsObj.allEvents objectAtIndex:i];

            int type = 0x00000001 << evt.eventType;

            if( (type & _filter) > 0) {
                [events addObject:evt];
            }
        }

        return events;
        
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
