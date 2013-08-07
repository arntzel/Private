//
//  CoreDataModel.h
//  calender
//
//  Created by xiangfang on 13-7-31.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>  

#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"
#import "MessageEntityExtra.h"
#import "DataCache.h"

@interface CoreDataModel : NSObject

-(DataCache *) getCache;


-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andPreLimit:(int) limit andEventTypeFilter:(int) eventTypeFilter;

-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andFollowLimit:(int) limit andEventTypeFilter:(int) eventTypeFilter;


-(NSArray*) getFeedEvents:(NSString *) day evenTypeFilter:(int) filter;

-(int) getDayFeedEventType:(NSString *) day;


-(void) addFeedEventEntitys:(NSArray *) entitys;

-(void) addFeedEventEntity:(FeedEventEntity*) entity;



//Begin for Message notification
-(int) getMessageCount;

-(MessageEntity *) getMessage:(int) offset;

-(MessageEntity *) getMessageByID:(int) msgID;
//End for Message notification


-(id) createEntity:(NSString *) entityName;


-(void) saveData;


+(CoreDataModel *) getInstance;


@end
