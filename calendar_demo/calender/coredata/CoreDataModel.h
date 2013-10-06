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

@protocol CoreDataModelDelegate <NSObject>

-(void) onCoreDataModelChanged;

@end



@interface CoreDataModel : NSObject


-(void) addDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) removeDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) notifyModelChange;


-(DataCache *) getCache;


-(NSArray *) getPendingFeedEventEntitys;


-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andPreLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter;

-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andFollowLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter;


-(FeedEventEntity*) getFeedEventEntity:(int) id;


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


-(void) reset;

@end
