//
//  LocationEntity.h
//  Calvin
//
//  Created by fang xiang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * photo;

@end
