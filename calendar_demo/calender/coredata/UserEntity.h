//
//  UserEntity.h
//  Calvin
//
//  Created by fang xiang on 13-10-21.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactEntity, FeedEventEntity;

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * apikey;
@property (nonatomic, retain) NSNumber * calvinUser;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * is_owner;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) FeedEventEntity *feedEvent;
@property (nonatomic, retain) ContactEntity *contact;

@end
