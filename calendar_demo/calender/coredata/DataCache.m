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

-(id) init:(DayFeedEventEntitys *) entitys
{
    self = [super init];
    
    self.day = entitys.day;
    self.dayFeedEvents = entitys;
    
    return  self;
}

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
    
    NSArray * allDays;
    
    NSMutableDictionary * dict;
    NSMutableDictionary * dayEventTypeWrapDict;
}

-(id) init
{
    self = [super init];
    
    dict = [[NSMutableDictionary alloc] init];
    dayEventTypeWrapDict = [[NSMutableDictionary alloc] init];
    
    
    return self;
}

-(void) clearAllDayFeedEventEntitys
{
    [dict removeAllObjects];
    allDays = nil;
}

-(NSArray *) allDays
{
    if(allDays == nil) {
        allDays = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString * day1 = (NSString *)obj1;
            NSString * day2 = (NSString *)obj2;
            return [day1 compare:day2];
        }];
    }
    
    return allDays;
}

-(void) putDayFeedEventEntitysWraps: (NSArray *) wraps
{
    for(DayFeedEventEntitysWrap * wrap in wraps) {
        [dict setObject:wrap forKey:wrap.day];
    }
   
    allDays = nil;
}

-(void) putDayFeedEventEntitysWrap:(DayFeedEventEntitysWrap *) wrap
{
    [dict setObject:wrap forKey:wrap.day];
    allDays = nil;
}

-(DayFeedEventEntitysWrap *) getDayFeedEventEntitysWrap:(NSString *) day
{
    return  [dict objectForKey:day];
}

-(void) removeDayFeedEventEntitysWrap:(NSString *) day
{
    [dayEventTypeWrapDict removeObjectForKey:day];
    allDays = nil;
}

-(void) putDayEventTypeWrap:(DayEventTypeWrap *) wrap
{
    [dayEventTypeWrapDict setObject:wrap forKey:wrap.day];
}

-(void) removeDayEventTypeWrap:(NSString *)day
{
    [dayEventTypeWrapDict removeObjectForKey:day];
}

-(DayEventTypeWrap *) getDayEventTypeWrap:(NSString *) day
{
    return [dayEventTypeWrapDict objectForKey:day];
}

@end
