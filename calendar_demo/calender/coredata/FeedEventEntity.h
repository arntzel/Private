//
//  FeedEventEntity.h
//  Calvin
//
//  Created by fang xiang on 13-10-21.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserEntity;

@interface FeedEventEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
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
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_all_day;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userstatus;
@property (nonatomic, retain) NSSet *attendees;

//--------------add by Vale
@property (nonatomic, retain) NSString *ext_event_id;
@property (nonatomic, retain) NSNumber *hasModified;
@property (nonatomic, retain) NSDate *last_modified;
//-------------------
@end

@interface FeedEventEntity (CoreDataGeneratedAccessors)

- (void)addAttendeesObject:(UserEntity *)value;
- (void)removeAttendeesObject:(UserEntity *)value;
- (void)addAttendees:(NSSet *)values;
- (void)removeAttendees:(NSSet *)values;

@end
