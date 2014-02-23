//
//  FeedEventEntity.h
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CreatorEntity, LocationEntity;

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
@property (nonatomic, retain) NSDate * max_proposed_end_time;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * start_type;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * userstatus;
@property (nonatomic, retain) NSNumber * all_responded;
@property (nonatomic, retain) NSNumber * allow_attendee_invite;
@property (nonatomic, retain) NSNumber * allow_new_dt;
@property (nonatomic, retain) NSNumber * allow_new_location;
@property (nonatomic, retain) NSNumber * attendee_num;
@property (nonatomic, retain) NSString * modified_num;
@property (nonatomic, retain) CreatorEntity *creator;
@property (nonatomic, retain) LocationEntity *location;

@end
