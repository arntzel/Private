//
//  CoreDataModel.m
//  calender
//
//  Created by xiangfang on 13-7-31.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "CoreDataModel.h"
#import "Utils.h"
#import "DayFeedEventEntitysExtra.h"
#import "DataCache.h"

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
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"events.sqlite"]];

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:storeUrl error: &error];
    LOG_D(@"error=%@", error);
}

-(id) init
{
    self = [super init];
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
       
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];
    return self;
}



-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"events.sqlite"]];
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

    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];

    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

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

-(FeedEventEntity*) getFeedEventEntity:(int) id
{
    
    NSLog(@"NSFetchRequest: getFeedEventEntity:%d", id);
   
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    //fetchRequest.propertiesToFetch =
    //[fetchRequest setFetchBatchSize:20];
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


-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andPreLimit:(int) limit andEventTypeFilter:(int) eventTypeFilter
{
    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:%@", date);
    
    NSString * beginDay = [Utils formateDay:date];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day < %@) AND (eventType & %d)>0", beginDay, eventTypeFilter];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}

-(NSArray *) getDayFeedEventEntitys:(NSDate *) date andFollowLimit:(int) limit  andEventTypeFilter:(int) eventTypeFilter
{
    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:%@", date);
    
    NSString * beginDay = [Utils formateDay:date];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day >= %@) AND (eventType & %d)>0", beginDay, eventTypeFilter];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setFetchOffset:0];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}

//-(NSArray *) getDayFeedEventEntitys:(NSDate *) beginDate andEndDay:(NSDate*) endDate
//{
//    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:%@-%@", beginDate, endDate);
//    
//    NSString * beginDay = [Utils formateDay:beginDate];
//    NSString * endDay = [Utils formateDay:endDate];
//    
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entity];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day >= %@ AND day< %@)", beginDay, endDay];
//    [fetchRequest setPredicate:predicate];
//    
//    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    return results;
//}

-(DayFeedEventEntitys *) getDayFeedEventEntitys:(NSString *) day
{
    
    NSLog(@"NSFetchRequest: getDayFeedEventEntitys:%@", day);
   
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    //fetchRequest.propertiesToFetch =
    //[fetchRequest setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day = %@)", day];
    [fetchRequest setPredicate:predicate];
    
     NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if(results.count >0) {
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
    NSLog(@"getDayFeedEventEntitys,day=%@, filter=%d", day, filter);
    
    DayFeedEventEntitysWrap * wrap = [cache getDayFeedEventEntitysWrap:day];
    
    if(wrap != nil) {
        if(wrap.eventTypeFilter != filter) {
            wrap.eventTypeFilter = filter;
            [wrap resetSortedEvents];
        }
        return wrap.sortedEvents;
    } 
    
    wrap = [[DayFeedEventEntitysWrap alloc] init];
    DayFeedEventEntitys * entitys = [self getDayFeedEventEntitys:day];
    wrap.day = day;
    wrap.dayFeedEvents = entitys;
    wrap.eventTypeFilter = filter;
    [wrap resetSortedEvents];
    
    return wrap.sortedEvents;
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
    
    //NSLog(@"NSFetchRequest: getDayFeedEventType:%@", day);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
  
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"eventType"]];
    fetchRequest.resultType = NSDictionaryResultType;
    
    //[fetchRequest setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day = %@)", day];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    int eventType = 0;
    if(results.count >0) {
        NSDictionary * dic = [results objectAtIndex:0];
        eventType = [[dic objectForKey:@"eventType"] intValue];
    }
    
    wrap = [[DayEventTypeWrap alloc] init];
    wrap.day = day;
    wrap.eventType = eventType;
    [cache putDayEventTypeWrap:wrap];
    
    return eventType;
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
    NSString * day = [Utils formateDay:entity.start];
  
    DayFeedEventEntitys * dayEntitys = [self getDayFeedEventEntitys:day];
    
    if(dayEntitys == nil) {
        
        dayEntitys = [self createEntity:@"DayFeedEventEntitys"];
        dayEntitys.day = day;
        
    } else {
        
        for(FeedEventEntity * ent in dayEntitys.events) {
            if([ent.id isEqualToNumber:entity.id]) {
                [dayEntitys removeEventsObject:ent];
                break;
            } 
        }
    }
    
    
    [dayEntitys addEventsObject:entity];

    int type = 0;
    for(FeedEventEntity * ent in dayEntitys.events) {
        type |= (0x00000001 << [ent.eventType intValue]);
    }

    dayEntitys.eventType = [NSNumber numberWithInt:type];
    
    if([cache containDay:day]) {
        DayFeedEventEntitysWrap * oldWrap = [cache getDayFeedEventEntitysWrap:day];
        if(oldWrap != nil) {
            oldWrap.dayFeedEvents = dayEntitys;
            [oldWrap resetSortedEvents];
        } else {
            DayFeedEventEntitysWrap * wrap = [[DayFeedEventEntitysWrap alloc] init:dayEntitys];
            [cache putDayFeedEventEntitysWrap:wrap];
        }
    }
    
    [cache removeDayEventTypeWrap:day];
}

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
