//
//  FeedEventEntity.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserEntity;

@interface FeedEventEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSString * belongToiCal;
@property (nonatomic, retain) NSNumber * confirmed;
@property (nonatomic, retain) NSDate * created_on;
@property (nonatomic, retain) NSString * creatoremail;
@property (nonatomic, retain) NSNumber * creatorID;
@property (nonatomic, retain) NSString * descript;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSNumber * duration_days;
@property (nonatomic, retain) NSNumber * duration_hours;
@property (nonatomic, retain) NSNumber * duration_minutes;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSString * ext_event_id;
@property (nonatomic, retain) NSNumber * hasDeleted;
@property (nonatomic, retain) NSNumber * hasModified;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_all_day;
@property (nonatomic, retain) NSDate * last_modified;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSDate * maxProposeStarTime;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userstatus;
@property (nonatomic, retain) NSSet *attendees;
@property (nonatomic, retain) NSSet *propose_starts;
@end

@interface FeedEventEntity (CoreDataGeneratedAccessors)

- (void)addAttendeesObject:(UserEntity *)value;
- (void)removeAttendeesObject:(UserEntity *)value;
- (void)addAttendees:(NSSet *)values;
- (void)removeAttendees:(NSSet *)values;

- (void)addPropose_startsObject:(NSManagedObject *)value;
- (void)removePropose_startsObject:(NSManagedObject *)value;
- (void)addPropose_starts:(NSSet *)values;
- (void)removePropose_starts:(NSSet *)values;

@end

//@interface FeedEventEntity (transient)
//@property (nonatomic, retain) NSNumber * lastForThisDay;
//
//@end
