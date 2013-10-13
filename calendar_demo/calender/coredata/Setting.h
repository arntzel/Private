//
//  Setting.h
//  Calvin
//
//  Created by xiangfang on 13-10-13.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Setting : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;

@end
