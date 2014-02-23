//
//  ProposeStartEntity.h
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventTimeVoteEntity;

@interface ProposeStartEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * duration_days;
@property (nonatomic, retain) NSNumber * duration_hours;
@property (nonatomic, retain) NSNumber * duration_minutes;
@property (nonatomic, retain) NSNumber * finalized;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_all_day;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSSet *votes;
@end

@interface ProposeStartEntity (CoreDataGeneratedAccessors)

- (void)addVotesObject:(EventTimeVoteEntity *)value;
- (void)removeVotesObject:(EventTimeVoteEntity *)value;
- (void)addVotes:(NSSet *)values;
- (void)removeVotes:(NSSet *)values;

@end
