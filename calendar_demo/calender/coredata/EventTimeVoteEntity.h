//
//  EventTimeVoteEntity.h
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventTimeVoteEntity : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * status;

@end
