//
//  ProposeStartEntity.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EventTimeVoteEntity.h"

@interface ProposeStartEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSNumber * duration_days;
@property (nonatomic, retain) NSNumber * duration_minutes;
@property (nonatomic, retain) NSNumber * duration_hours;
@property (nonatomic, retain) NSNumber * is_all_day;
@property (nonatomic, retain) NSNumber * finalized;
@property (nonatomic, retain) NSSet *votes;
@end

@interface ProposeStartEntity (CoreDataGeneratedAccessors)

- (void)addVotesObject:(NSManagedObject *)value;
- (void)removeVotesObject:(NSManagedObject *)value;
- (void)addVotes:(NSSet *)values;
- (void)removeVotes:(NSSet *)values;

@end
