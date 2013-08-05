//
//  CoreDataModel.m
//  calender
//
//  Created by xiangfang on 13-7-31.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "CoreDataModel.h"
#import "Utils.h"

static CoreDataModel * instance;

@implementation CoreDataModel {

    //数据模型对象
    NSManagedObjectModel * managedObjectModel;

    //上下文对象
    NSManagedObjectContext * managedObjectContext;

    //持久性存储区
    NSPersistentStoreCoordinator * persistentStoreCoordinator;

}

-(id) init
{
    self = [super init];
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Model.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
    {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    NSPersistentStoreCoordinator *coordinator =[self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc]init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
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
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"coredata.sqlite"]];
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


-(id) createEntity:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
}



-(DayFeedEventEntitys *) getDayFeedEventEntitys:(NSString *) day
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    //fetchRequest.propertiesToFetch =
    //[fetchRequest setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day = '%@')", day];
    [fetchRequest setPredicate:predicate];
    
     NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if(results.count >0) {
        return [results objectAtIndex:0];
    }
    
    return nil;
}

-(int) getDayFeedEventType:(NSString *) day
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayFeedEventEntitys" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
  
    fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"eventType"]];
    fetchRequest.resultType = NSDictionaryResultType;
    
    //[fetchRequest setFetchBatchSize:20];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(day = '%@')", day];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if(results.count >0) {
        NSDictionary * dic = [results objectAtIndex:0];
        return [[dic objectForKey:@"eventType"] intValue];
    }
    
    return 0;

}


-(void) addFeedEventEntitys:(NSArray *) entitys
{
    for (FeedEventEntity * entity in entitys) {
        [self addFeedEventEntity:entity];
    }
}

-(void) addFeedEventEntity:(FeedEventEntity*) entity
{
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
