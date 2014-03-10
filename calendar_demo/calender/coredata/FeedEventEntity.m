//
//  FeedEventEntity.m
//  Calvin
//
//  Created by fangxiang on 14-3-10.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "FeedEventEntity.h"
#import "CreatorEntity.h"
#import "EventAttendeeEntity.h"
#import "LocationEntity.h"
#import "ProposeStartEntity.h"


@implementation FeedEventEntity

@dynamic all_responded;
@dynamic allow_attendee_invite;
@dynamic allow_new_dt;
@dynamic allow_new_location;
@dynamic archived;
@dynamic attendee_num;
@dynamic belongToiCal;
@dynamic confirmed;
@dynamic created_on;
@dynamic creatoremail;
@dynamic creatorID;
@dynamic descript;
@dynamic duration;
@dynamic duration_days;
@dynamic duration_hours;
@dynamic duration_minutes;
@dynamic end;
@dynamic eventType;
@dynamic ext_event_id;
@dynamic hasDeleted;
@dynamic hasModified;
@dynamic id;
@dynamic is_all_day;
@dynamic last_modified;
@dynamic locationName;
@dynamic max_proposed_end_time;
@dynamic modified_num;
@dynamic start;
@dynamic start_type;
@dynamic thumbnail_url;
@dynamic timezone;
@dynamic title;
@dynamic userstatus;
@dynamic vote;
@dynamic attendees;
@dynamic creator;
@dynamic location;
@dynamic propose_starts;

@end
