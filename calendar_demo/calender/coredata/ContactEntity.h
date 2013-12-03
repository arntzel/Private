//
//  ContactEntity.h
//  Calvin
//
//  Created by fang xiang on 13-10-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactEntity : NSManagedObject

@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSNumber * calvinuser;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * fullname;

@end
