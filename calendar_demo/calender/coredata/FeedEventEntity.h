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

@property (nonatomic, strong) NSNumber * archived;
@property (nonatomic, strong) NSNumber * confirmed;
@property (nonatomic, strong) NSDate * created_on;
@property (nonatomic, strong) NSString * creatoremail;
@property (nonatomic, strong) NSNumber * creatorID;
@property (nonatomic, strong) NSString * descript;
@property (nonatomic, strong) NSString * duration;
@property (nonatomic, strong) NSNumber * duration_days;
@property (nonatomic, strong) NSNumber * duration_hours;
@property (nonatomic, strong) NSNumber * duration_minutes;
@property (nonatomic, strong) NSDate * end;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * is_all_day;
@property (nonatomic, strong) NSString * locationName;
@property (nonatomic, strong) NSDate * start;
@property (nonatomic, strong) NSString * start_type;
@property (nonatomic, strong) NSString * thumbnail_url;
@property (nonatomic, strong) NSString * timezone;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * userstatus;
@property (nonatomic, strong) NSSet *attendees;

//--------------add by Vale
@property (nonatomic, strong) NSString *ext_event_id;
@property (nonatomic, strong) NSNumber *hasModified;
//-------------------
@end

@interface FeedEventEntity (CoreDataGeneratedAccessors)

- (void)addAttendeesObject:(UserEntity *)value;
- (void)removeAttendeesObject:(UserEntity *)value;
- (void)addAttendees:(NSSet *)values;
- (void)removeAttendees:(NSSet *)values;

@end
