//
//  DataCache.h
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayFeedEventEntitysExtra.h"

@interface DayFeedEventEntitysWrap : NSObject

-(id) init:(DayFeedEventEntitys *) entitys;


@property NSString * day;
@property(strong) DayFeedEventEntitys * dayFeedEvents;
@property int eventTypeFilter;


@property NSArray * sortedEvents;

-(void) resetSortedEvents;

@end


@interface DayEventTypeWrap : NSObject

@property (strong) NSString * day;
@property int eventType;

@end


@interface DataCache : NSObject


-(void) clearAllDayFeedEventEntitys;

-(NSArray *) allDays;

-(DayFeedEventEntitysWrap *) getDayFeedEventEntitysWrap:(NSString *) day;

-(void) putDayFeedEventEntitysWraps: (NSArray *) wraps;

-(void) putDayFeedEventEntitysWrap:(DayFeedEventEntitysWrap *) wrap;

-(void) removeDayFeedEventEntitysWrap:(NSString *) day;



-(void) putDayEventTypeWrap:(DayEventTypeWrap *) wrap;
-(void) removeDayEventTypeWrap:(NSString *)day;
-(DayEventTypeWrap *) getDayEventTypeWrap:(NSString *) day;


@end
