//
//  DayFeedEventEntitysExtra.m
//  calender
//
//  Created by xiangfang on 13-8-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "DayFeedEventEntitysExtra.h"
#import "FeedEventEntity.h"


@implementation  DayFeedEventEntitys (DayFeedEventEntitysExtra) 

-(NSArray *) getEvents
{

    NSMutableArray *  events = [[NSMutableArray alloc] init];
    for(FeedEventEntity * entity in self.events) {
        [events addObject:entity];
    }

    NSArray * sortedArray = [events sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        FeedEventEntity * evt1 = obj1;
        FeedEventEntity * evt2 = obj2;
        return [evt1.start compare:evt2.start];
    }];

    return sortedArray;
}

@end
