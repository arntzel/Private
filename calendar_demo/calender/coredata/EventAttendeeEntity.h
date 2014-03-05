//
//  EventAttendeeEntity.h
//  Calvin
//
//  Created by fangxiang on 14-3-5.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FeedEventEntity.h"


@interface EventAttendeeEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * invite_key;
@property (nonatomic, retain) NSNumber * is_owner;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * fullname;

@end
