
#import "EventModel.h"
#import "Event.h"
#import "Utils.h"

@implementation EventModel {

    NSArray * alldays;

    NSMutableDictionary * dayEvents;

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

    if([monthEvents objectForKey:month] == nil) {
        [monthEvents setObject:events forKey:month];

        for(int i=0;i<events.count;i++) {
            Event * event = [events objectAtIndex:i];

            NSString * day = [Utils formateDay:event.start];

            NSMutableArray * array = [dayEvents objectForKey:day];
            if(array == nil) {
                array = [[NSMutableArray alloc] init];
                [dayEvents setObject:array forKey:day];
            }

            [array addObject:event];
        }

        alldays = [[dayEvents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * str1 = obj1;
            NSString * str2 = obj2;
            return [str2 compare:str1];
        }];
        
    } else {
        assert(NO);
    }
}


-(NSArray *) getEventsByMonth:(NSString *) month {
    return [monthEvents objectForKey:month];
}

-(NSArray *) getEventsByDay:(NSString *) day {
    return [dayEvents objectForKey:day];
}

-(NSArray *) getAllDays {
    return alldays;
}


@end
