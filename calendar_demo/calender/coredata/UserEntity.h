//
//  UserEntity.h
//  calender
//
//  Created by xiangfang on 13-8-5.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * apikey;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * creatorID;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * username;

@end
