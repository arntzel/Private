//
//  DataCache.m
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "DataCache.h"
#import "FeedEventEntity.h"

@implementation DayFeedEventEntitysWrap


-(void) resetSortedEvents
{
    if(self.dayFeedEvents == nil)
    {
        self.sortedEvents = nil;
        return;
    }
    
    NSMutableArray *  events = [[NSMutableArray alloc] init];
    for(FeedEventEntity * entity in self.dayFeedEvents.events) {
        int type = 0x00000001 << [entity.eventType intValue];;
        if( (type & self.eventTypeFilter) != 0) {
            [events addObject:entity];
        }
    }
    
    if(events.count==0) {
        self.sortedEvents = events;
        return;
    }
    
    NSArray * sortedArray = [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FeedEventEntity * evt1 = obj1;
        FeedEventEntity * evt2 = obj2;
        return [evt1.start compare:evt2.start];
    }];
    
    self.sortedEvents = sortedArray;
}

@end

@implementation DayEventTypeWrap

@end


@implementation DataCache {
    
    NSMutableArray * array;
    NSMutableDictionary * dict;
    
    
    NSMutableArray * dayEventTypeWrapArray;
    NSMutableDictionary * dayEventTypeWrapDict;
}

-(id) init
{
    self = [super init];
    
    array = [[NSMutableArray alloc] init];
    dict = [[NSMutableDictionary alloc] init];
    
    dayEventTypeWrapArray = [[NSMutableArray alloc] init];
    dayEventTypeWrapDict = [[NSMutableDictionary alloc] init];
    
    
    return self;
}

-(void) putDayFeedEventEntitysWrap:(DayFeedEventEntitysWrap *) wrap
{
//    if(dict.count > 300) {
//        DayFeedEventEntitysWrap * first = [array objectAtIndex:0];
//        [array removeObjectAtIndex:0];
//        [dict removeObjectForKey:first.day];
//    }
    
    [array addObject:wrap];
    [dict setObject:wrap forKey:wrap.day];
}

-(DayFeedEventEntitysWrap *) getDayFeedEventEntitysWrap:(NSString *) day
{
    return  [dict objectForKey:day];
}


-(void) putDayEventTypeWrap:(DayEventTypeWrap *) wrap
{
//    if(dayEventTypeWrapDict.count > 300) {
//        DayEventTypeWrap * first = [dayEventTypeWrapArray objectAtIndex:0];
//        [dayEventTypeWrapArray removeObjectAtIndex:0];
//        [dayEventTypeWrapDict removeObjectForKey:first.day];
//    }
    
    [dayEventTypeWrapArray addObject:wrap];
    [dayEventTypeWrapDict setObject:wrap forKey:wrap.day];
}

-(DayEventTypeWrap *) getDayEventTypeWrap:(NSString *) day
{
    return [dayEventTypeWrapDict objectForKey:day];
}

@end
