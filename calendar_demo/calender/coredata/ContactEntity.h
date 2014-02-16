//
//  ContactEntity.h
//  Calvin
//
//  Created by fangxiang on 14-2-16.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactEntity : NSManagedObject

@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * calvinuser;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * lastest_timestamp;

@end
