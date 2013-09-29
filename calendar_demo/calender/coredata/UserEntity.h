//
//  UserEntity.h
//  Calvin
//
//  Created by fang xiang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * apikey;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * calvinUser;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * is_owner;

@end
