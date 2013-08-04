//
//  EventEntity.h
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationEntity, UserEntity;

@interface EventEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * allow_attendee_invite;
@property (nonatomic, retain) NSNumber * allow_new_dt;
@property (nonatomic, retain) NSNumber * allow_new_location;
@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSNumber * confirmed;
@property (nonatomic, retain) NSDate * created_on;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSNumber * duration_days;
@property (nonatomic, retain) NSNumber * duration_hours;
@property (nonatomic, retain) NSNumber * duration_minutes;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_all_day;
@property (nonatomic, retain) NSNumber * privilige;
@property (nonatomic, retain) NSNumber * published;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userstatus;
@property (nonatomic, retain) UserEntity *creator;
@property (nonatomic, retain) LocationEntity *location;
@property (nonatomic, retain) NSSet *attendees;
@end

@interface EventEntity (CoreDataGeneratedAccessors)

- (void)addAttendeesObject:(UserEntity *)value;
- (void)removeAttendeesObject:(UserEntity *)value;
- (void)addAttendees:(NSSet *)values;
- (void)removeAttendees:(NSSet *)values;

@end
