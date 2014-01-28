//
//  DataCache.h
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedEventEntity.h"

@interface DayFeedEventEntitysWrap : NSObject

-(id) init:(NSString *) day andFeedEvents:(NSArray *) feedEvents;


@property(strong) NSString * day;

@property int eventTypeFilter;

@property (strong) NSNumber * eventType;
@property (strong) NSMutableArray *events;

@property(strong) NSArray * sortedEvents;


-(void) removeEventsObject:(FeedEventEntity*) evt;

-(void) addEventsObject:(FeedEventEntity*) evt;

-(void) resetSortedEvents;

@end



@interface DayEventTypeWrap : NSObject

@property (strong) NSString * day;
@property int eventType;

@end




@interface DataCache : NSObject

//GMT date
@property(strong) NSDate * date;
@property int followCount;
@property int preCount;


-(void) clearAllDayFeedEventEntitys;

-(NSArray *) allDays;

-(NSMutableDictionary *) dict;

-(BOOL) containDay:(NSString *) day;


-(DayFeedEventEntitysWrap *) getDayFeedEventEntitysWrap:(NSString *) day;


-(void) putFeedEventEntitys:(NSArray *) feedEvents;

-(void) putFeedEventEntity:(FeedEventEntity *) feedEvent;

-(void) removeFeedEventEntity:(FeedEventEntity *) feedEvent;


-(void) putDayFeedEventEntitysWraps: (NSArray *) wraps;

-(void) putDayFeedEventEntitysWrap:(DayFeedEventEntitysWrap *) wrap;

-(void) removeDayFeedEventEntitysWrap:(NSString *) day;



-(void) putDayEventTypeWrap:(DayEventTypeWrap *) wrap;
-(void) removeDayEventTypeWrap:(NSString *)day;
-(DayEventTypeWrap *) getDayEventTypeWrap:(NSString *) day;

-(void) clearDayEventTypeWrap;

@end
