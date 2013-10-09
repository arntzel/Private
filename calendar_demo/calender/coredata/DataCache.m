//
//  DataCache.m
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "DataCache.h"
#import "FeedEventEntity.h"
#import "Utils.h"

@implementation DayFeedEventEntitysWrap

-(id) init:(NSString *) day andFeedEvents:(NSArray *) feedEvents
{
    self = [super init];
    
    self.day = day;
    self.events = [NSMutableArray arrayWithArray:feedEvents];
    
    return self;
}


-(void) removeEventsObject:(FeedEventEntity*) evt
{
    for(FeedEventEntity * ent in self.events) {
        if([ent.id isEqualToNumber:evt.id]) {
            [self.events removeObject:ent];
            break;
        }
    }
    
}

-(void) addEventsObject:(FeedEventEntity*) evt
{
    [self.events addObject:evt];
}


-(void) resetSortedEvents
{
    if(self.events == nil)
    {
        self.sortedEvents = nil;
        return;
    }
    
    NSMutableArray *  events = [[NSMutableArray alloc] init];
    for(FeedEventEntity * entity in self.events) {
        int type = [entity.eventType intValue];;
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

-(BOOL) containDay:(NSString *) day
{
    if(allDays.count==0) return NO;
    
    NSString * firstDay = [allDays objectAtIndex:0];
    NSString * lastDay = [allDays lastObject];

    if([day compare:firstDay] >= 0 && [day compare:lastDay] <= 0) {
        return YES;
    } else {
        return NO;
    }
}


-(void) putFeedEventEntitys:(NSArray *) feedEvents
{
    for(FeedEventEntity * feedEvent in feedEvents) {
        [self putFeedEventEntity:feedEvent];
    }

    allDays = nil;
}


-(void) putFeedEventEntity:(FeedEventEntity *) feedEvent
{
    NSString * day = [Utils formateDay:feedEvent.start];
    
    DayFeedEventEntitysWrap * wrap = [self getDayFeedEventEntitysWrap:day];
    
    if(wrap == nil) {
        NSArray * array = [NSArray arrayWithObject:feedEvent];
        wrap = [[DayFeedEventEntitysWrap alloc] init:day andFeedEvents:array];
        [dict setObject:wrap forKey:day];
    } else {
        [wrap addEventsObject:feedEvent];
    }
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
