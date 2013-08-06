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

@interface CoreDataModel : NSObject


-(id) createEntity:(NSString *) entityName;

-(FeedEventEntity*) getFeedEventEntity:(int)id;



-(NSArray*) getFeedEvents:(NSString *) day evenTypeFilter:(int) filter;

-(int) getDayFeedEventType:(NSString *) day;


-(void) addFeedEventEntitys:(NSArray *) entitys;

-(void) addFeedEventEntity:(FeedEventEntity*) entity;



//Begin for Message notification
-(int) getMessageCount;

-(MessageEntity *) getMessage:(int) offset;

-(MessageEntity *) getMessageByID:(int) msgID;
//End for Message notification


-(void) saveData;


+(CoreDataModel *) getInstance;


@end
