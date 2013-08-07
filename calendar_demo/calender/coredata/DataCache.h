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

-(void) putDayFeedEventEntitysWrap:(DayFeedEventEntitysWrap *) wrap;

-(DayFeedEventEntitysWrap *) getDayFeedEventEntitysWrap:(NSString *) day;


-(void) putDayEventTypeWrap:(DayEventTypeWrap *) wrap;

-(DayEventTypeWrap *) getDayEventTypeWrap:(NSString *) day;


@end
