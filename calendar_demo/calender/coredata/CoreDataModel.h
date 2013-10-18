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
#import "ContactEntityExtra.h"
#import "Setting.h"

#import "DataCache.h"

@protocol CoreDataModelDelegate <NSObject>

-(void) onCoreDataModelChanged;

@end



@interface CoreDataModel : NSObject


@property BOOL inited;

-(void) initDBContext:(User *) user;

-(void) addDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) removeDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) notifyModelChange;


-(DataCache *) getCache;


-(NSArray *) getPendingFeedEventEntitys;

//GMT date
-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andPreLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter;

//GMT date
-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andFollowLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter;


-(FeedEventEntity*) getFeedEventEntity:(int) id;


-(NSArray*) getFeedEvents:(NSString *) day evenTypeFilter:(int) filter;


//GMT date
-(int) getFeedEventCountByStart:(NSDate *) start andEnd:(NSDate *) end;



//user date
-(int) getDayFeedEventType:(NSString *) day;


-(void) addFeedEventEntitys:(NSArray *) entitys;

-(void) addFeedEventEntity:(FeedEventEntity*) entity;

-(void) updateFeedEventEntity:(FeedEventEntity*) entity;


-(void) deleteFeedEventEntity:(int) eventID;

-(void) deleteFeedEventEntity2:(FeedEventEntity *) entity;

//Begin for Message notification
-(int) getMessageCount;

-(MessageEntity *) getMessage:(int) offset;

-(MessageEntity *) getMessageByID:(int) msgID;
//End for Message notification


-(ContactEntity *) getContactEntity:(int) contactid;
/**
 *  get contact entity with phone and email
 *
 *  @param phone
 *  @param email
 *
 *  @return ContactEntity
 */
- (ContactEntity *) getContactEntityWith:(NSString *) phone AndEmail:(NSString *)email;
-(NSArray *) getAllContactEntity;


-(Setting *) getSetting:(NSString *) key;

-(void) saveSetting:(NSString *) key andValue:(NSString *) value;



-(id) createEntity:(NSString *) entityName;

-(void) deleteEntity:(NSManagedObject *) entity;

-(void) saveData;


+(CoreDataModel *) getInstance;


-(void) reset;

@end
