//
//  UserEntity.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactEntity, FeedEventEntity;

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * calvinUser;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_owner;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) ContactEntity *contact;
@property (nonatomic, retain) FeedEventEntity *feedEvent;

@end
