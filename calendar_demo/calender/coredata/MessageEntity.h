//
//  MessageEntity.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSString * senderUrl;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSNumber * unread;

@end
