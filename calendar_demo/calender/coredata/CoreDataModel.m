//
//  CoreDataModel.m
//  calender
//
//  Created by xiangfang on 13-7-31.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "CoreDataModel.h"
#import "Utils.h"
#import "NSDateAdditions.h"
#import "DataCache.h"
#import "UserModel.h"

static CoreDataModel * instance;

@implementation CoreDataModel {

    //数据模型对象
    NSManagedObjectModel * managedObjectModel;

    //上下文对象
    NSManagedObjectContext * managedObjectContext;

    //持久性存储区
    NSPersistentStoreCoordinator * persistentStoreCoordinator;

    NSMutableArray * delegates;
    
    DataCache * cache;
}

-(void) reset {
 
    managedObjectModel = nil;
    managedObjectContext = nil;
    persistentStoreCoordinator = nil;
    
    //Delete old db file
//    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"events.sqlite"]];
//    
//    NSError *error = nil;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtURL:storeUrl error: &error];
//    LOG_D(@"error=%@", error);

    

    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];

    self.inited = NO;
}

-(void) initDBContext:(User *) user
{
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator:user];

    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    self.inited = YES;
}

-(id) init
{
    self = [super init];

    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];

    return self;
}



-(NSPersistentStoreCoordinator *)persistentStoreCoordinator:(User *) user
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSString * dbname = [NSString stringWithFormat:@"calvin%d.sqlite", user.id];

    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:dbname]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];

    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }

    return persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    return managedObjectContext;
}



-(void) addDelegate:(id<CoreDataModelDelegate>) delegate
{
    [delegates addObject:delegate];
}

-(void) removeDelegate:(id<CoreDataModelDelegate>) delegate
{
    [delegates removeObject:delegate];
}

-(void) notifyModelChange
{
    for(id<CoreDataModelDelegate>  delegate in delegates) {
        [delegate onCoreDataModelChanged];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(FeedEventEntity*) getFeedEventEntity:(int) id
{
    
    //NSLog(@"NSFetchRequest: getFeedEventEntity:%d", id);
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", id];
    [fetchRequest setPredicate:predicate];

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];

    if(results.count >0) {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

-(id) createEntity:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
}


-(void) deleteEntity:(NSManagedObject *) entity
{
    [managedObjectContext deleteObject:entity];
}


-(NSArray *) getPendingFeedEventEntitys
{
    NSLog(@"NSFetchRequest: getPendingFeedEventEntitys");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"start = NULL"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}

-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andPreLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter
{
    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:andPreLimit:%@", date);
    
    NSArray * results = [self getFeedEventEntitys:date andFollow:NO andLimit:limit andOffset:offset andEventTypeFilter:eventTypeFilter];
    return results;
}

-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andFollowLimit:(int) limit  andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter
{
    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:andFollowLimit :%@", date);
    NSArray * results = [self getFeedEventEntitys:date andFollow:YES andLimit:limit andOffset:offset andEventTypeFilter:eventTypeFilter];
    return results;
}

-(NSArray *) getFeedEventEntitys:(NSDate *) date andFollow:(BOOL)follow andLimit:(int) limit andOffset:(int)offset andEventTypeFilter:(int) eventTypeFilter
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    NSSortDescriptor *sortDescriptor;
    
    if(follow) {
        predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start >= %@) AND (eventType & %d)>0", date, eventTypeFilter];
        //predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start >= %@)", date];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start < %@) AND (eventType & %d)>0", date, eventTypeFilter];
        //predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start < %@)", date];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:NO];
    }

    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}


-(NSArray *) getFeedEventEntitys:(NSDate *) day
{
    
    NSDate * beginDate = [Utils convertGMTDate:[day cc_dateByMovingToBeginningOfDay]];
    NSDate * endDate = [Utils convertGMTDate:[day cc_dateByMovingToEndOfDay]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    NSSortDescriptor *sortDescriptor;
    
    predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start >= %@) AND (start < %@)", beginDate, endDate];
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;

}
-(BOOL) getFeedEventEntityWithCreateTime:(NSDate *) createTime
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext1 = [[NSManagedObjectContext alloc]init];
    [managedObjectContext1 setPersistentStoreCoordinator:persistentStoreCoordinator];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext1];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"created_on = %@", createTime];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray * results = [managedObjectContext1 executeFetchRequest:fetchRequest error:&error];
    LOG_D(@"error:%@",error);
    if ([results count]>0)
    {
        return YES;
    }

    return NO;
    
}

- (FeedEventEntity *)getFeedEventWithEventType:(int)eventType WithExtEventID:(NSString *)ext_event_id
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"eventType=%@ && ext_event_id=%@", @(eventType), ext_event_id];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([results count] > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}
-(DataCache *) getCache
{
    return cache;
}


-(NSArray*) getFeedEvents:(NSString *) day  evenTypeFilter:(int) filter;
{
    NSLog(@"getFeedEvents,day=%@, filter=%d", day, filter);
    
    DayFeedEventEntitysWrap * wrap = [cache getDayFeedEventEntitysWrap:day];
    
    if(wrap != nil) {
        if(wrap.eventTypeFilter != filter) {
            wrap.eventTypeFilter = filter;
            [wrap resetSortedEvents];
        }
        return wrap.sortedEvents;
    } 
    
    NSDate * date = [Utils parseNSStringDay:day];

    
    NSArray * entitys = [self getFeedEventEntitys:date];
    
    wrap = [[DayFeedEventEntitysWrap alloc] init:day andFeedEvents:entitys];

    wrap.eventTypeFilter = filter;
    [wrap resetSortedEvents];
    
    return wrap.sortedEvents;
} 


-(int) getFeedEventCountByStart:(NSDate *) start andEnd:(NSDate *) end;
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"( ((start >= %@) AND (start <= %@))  OR ((end >= %@) AND (end <= %@)) ) AND (eventType & %d)>0", start,  end, start,  end, FILTER_IMCOMPLETE];
    [fetchRequest setPredicate:predicate];
    return [managedObjectContext countForFetchRequest:fetchRequest error:nil];
}


-(int) getDayFeedEventType:(NSString *) day
{
    if(day == nil) {
        return 0;
    }
    
    DayEventTypeWrap * wrap = [cache getDayEventTypeWrap:day];
    if(wrap != nil) {
        return wrap.eventType;
    }
    
    
    //LOG_D(@"getDayFeedEventType：%@", day);
    
    NSDate * date = [Utils parseNSStringDay:day];
    NSDate * beginDate = [Utils convertGMTDate:[date cc_dateByMovingToBeginningOfDay]];
    NSDate * endDate = [Utils convertGMTDate:[date cc_dateByMovingToEndOfDay]];
    
  

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
  
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"eventType"]];
    fetchRequest.resultType = NSDictionaryResultType;
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(start != NULL AND start >= %@ AND start < %@)", beginDate, endDate];
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(start != NULL)"];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    int eventType = 0;
    for(NSDictionary * dic in results) {
        int type = [[dic objectForKey:@"eventType"] intValue];
        eventType |= type;
    }
    
    
    wrap = [[DayEventTypeWrap alloc] init];
    wrap.day = day;
    wrap.eventType = eventType;
    [cache putDayEventTypeWrap:wrap];
    
    return eventType;
}

-(void) updateFeedEventEntity:(FeedEventEntity*) entity
{
    [cache clearDayEventTypeWrap];
}

-(void) addFeedEventEntitys:(NSArray *) entitys
{
    for (FeedEventEntity * entity in entitys) {
        [self addFeedEventEntity:entity];
    }
}

-(void) addFeedEventEntity:(FeedEventEntity*) entity
{
    NSLog(@"addFeedEventEntity");
    
    if(entity.start != nil) {
       
        NSString * day = [Utils formateDay:[entity getLocalStart]];
        
    
        if([cache containDay:day]) {
            DayFeedEventEntitysWrap * oldWrap = [cache getDayFeedEventEntitysWrap:day];
            if(oldWrap != nil) {
                [oldWrap addEventsObject:entity];
                [oldWrap resetSortedEvents];
            } else {
                NSArray * array = [NSArray arrayWithObject:entity];
                DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:day andFeedEvents:array];
                [cache putDayFeedEventEntitysWrap:wrap];
            }
        }
        
        [cache removeDayEventTypeWrap:day];
    }
}

-(void) deleteFeedEventEntity2:(FeedEventEntity *) entity
{
    [cache removeFeedEventEntity:entity];
    [managedObjectContext deleteObject:entity];
}

-(void) deleteFeedEventEntity:(int) eventID
{
    FeedEventEntity * entity = [self getFeedEventEntity:eventID];
    
    if(entity  != nil) {
        [cache removeFeedEventEntity:entity];
        [managedObjectContext deleteObject:entity];
        [self saveData];
        [self notifyModelChange];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//For Message
-(int) getMessageCount
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MessageEntity"];
    int count = [managedObjectContext countForFetchRequest:fetchRequest error:NULL];
    return count;
}

-(MessageEntity *) getMessage:(int) offset
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:1];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sendTime" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if(results.count >0) {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

-(MessageEntity *) getMessageByID:(int) msgID
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MessageEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", msgID];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if(results.count >0) {
        return [results objectAtIndex:0];
    }
    
    return nil;
}


-(ContactEntity *) getContactEntity:(int) contactid
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", contactid];
    [fetchRequest setPredicate:predicate];

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];

    if(results.count >0) {
        return [results objectAtIndex:0];
    }

    return nil;
}

-(NSArray *) getContactEntitysWithID:(int) contactid
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", contactid];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}
-(NSArray *) getAllContactEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}

- (ContactEntity *) getContactEntityWith:(NSString *) phone AndEmail:(NSString *)email
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext1 = [[NSManagedObjectContext alloc]init];
    [managedObjectContext1 setPersistentStoreCoordinator:persistentStoreCoordinator];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext1];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(phone = %@ AND email = %@)", phone, email];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext1 executeFetchRequest:fetchRequest error:nil];
    managedObjectContext1 = nil;
    if(results.count >0)
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

- (void)deleteContactEntityWith:(NSString *)phone andEmail:(NSString *)email
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(phone = %@ AND email = %@)", phone, email];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    ContactEntity *entity = [results objectAtIndex:0];
    NSLog(@"entity.phone = %@, entity.email = %@",entity.phone,entity.email);
    [managedObjectContext deleteObject:entity];
    //[self saveData];
}
-(Setting *) getSetting:(NSString *) key
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@", key];
    [fetchRequest setPredicate:predicate];

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if(results.count >0) {
        return [results objectAtIndex:0];
    }

    return nil;
}

-(void) saveSetting:(NSString *) key andValue:(NSString *) value
{
    Setting * setting = [self getSetting:key];
    if(setting == nil) {
        setting = [self createEntity:@"Setting"];
    }

    setting.key = key;
    setting.value = value;
    [self saveData];
}

-(void) saveData
{
    [managedObjectContext save:nil];
}


+(CoreDataModel *) getInstance
{
    if(instance == nil) {
        instance = [[CoreDataModel alloc] init];
    }
    return instance;
}

@end
