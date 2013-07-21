
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

    NSArray * sortedArray = [self.allEvents sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Event * evt1 = obj1;
        Event * evt2 = obj2;
        return [evt2.start compare:evt1.start];
    }];

    self.allEvents = [[NSMutableArray alloc] initWithArray:sortedArray];
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
@implementation EventModel {

    int _filter;
    
    NSArray * alldays;

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
        [dayEvents setObject:dayObj forKey:day];
    }

    [dayObj addEvent:newEvent];
}

-(void) setFilter:(int) filter
{
    _filter = filter;
    [self rebuildDaysArray];
}

-(void) rebuildDaysArray
{
    alldays = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = obj1;
        NSString * str2 = obj2;
        return [str1 compare:str2];
    }];
}

-(NSArray *) getEventsByDay:(NSString *) day {
    
    DayEventsObject * dayEventsObj = [dayEvents objectForKey:day];

    if(dayEventsObj != nil) {


//        if(_filter==0) {
//            return dayEventsObj.allEvents;
//        }


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
