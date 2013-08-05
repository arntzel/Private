//
//  DayFeedEventEntitys.h
//  calender
//
//  Created by fang xiang on 13-8-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedEventEntity;

@interface DayFeedEventEntitys : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSSet *events;
@end

@interface DayFeedEventEntitys (CoreDataGeneratedAccessors)

- (void)addEventsObject:(FeedEventEntity *)value;
- (void)removeEventsObject:(FeedEventEntity *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
