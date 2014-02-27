#import "CoreDataModel.h"
#import "Utils.h"
#import "NSDateAdditions.h"
#import "DataCache.h"
#import "UserModel.h"
#import <EventKit/EventKit.h>
static CoreDataModel * instance;

@implementation CoreDataModel {

    //数据模型对象
    //NSManagedObjectModel * managedObjectModel;

    //上下文对象
    NSManagedObjectContext * managedObjectContext;

    //持久性存储区
    //NSPersistentStoreCoordinator * persistentStoreCoordinator;

    NSMutableArray * delegates;
    
    DataCache * cache;
}

-(void) reset {
 
    managedObjectContext = nil;
    
    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];

    self.inited = NO;
}

-(void) initDBContext:(User *) user
{
    NSPersistentStoreCoordinator * coordinator =[self persistentStoreCoordinator:user];

    managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];

    self.inited = YES;
}

-(id) init
{
    self = [super init];

    delegates = [[NSMutableArray alloc] init];
    cache = [[DataCache alloc] init];

    return self;
}



-(NSPersistentStoreCoordinator *) persistentStoreCoordinator:(User *) user
{
    NSString * dbname = [NSString stringWithFormat:@"calvin%d.sqlite", user.id];

    NSManagedObjectModel * managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //得到数据库的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeUrl = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:dbname]];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator * persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
   
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }

    
    return persistentStoreCoordinator;
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
    [cache clearDayEventTypeWrap];
    for(id<CoreDataModelDelegate>  delegate in delegates) {
        [delegate onCoreDataModelChanged];
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(FeedEventEntity*) getFeedEventEntity:(int) id
{
    
    //NSLog(@"NSFetchRequest: getFeedEventEntity:%d", id);
    
    if (managedObjectContext == nil)
        
    {
        return nil;
    }
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"confirmed = false"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_on" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    LOG_I(@"NSFetchRequest: getPendingFeedEventEntitys, count:%d", results.count);
    
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
        [self getFeedEventWithEventType:5];
        predicate = [NSPredicate predicateWithFormat:@"(confirmed = true) AND (start >= %@) AND (eventType & %d)>0 AND belongToiCal=%@", date, eventTypeFilter,@"0"];
        //predicate = [NSPredicate predicateWithFormat:@"(start != NULL) AND (start >= %@)", date];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(confirmed = true) AND (start < %@) AND (eventType & %d)>0 AND belongToiCal=%@", date, eventTypeFilter,@"0"];
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


-(NSArray *) getDayFeedEventEntitys:(NSDate *) begin andEndDate:(NSDate *) end
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(confirmed = true) AND (start >= %@) AND (start<%@)", begin, end];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];

    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}

-(NSArray *) getFeedEventEntitys:(NSDate *) day
{
    
    NSDate * beginDate = [day cc_dateByMovingToBeginningOfDay];
    NSDate * endDate = [day cc_dateByMovingToEndOfDay];
    
    return [self getDayFeedEventEntitys:beginDate andEndDate:endDate];
    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    NSPredicate *predicate;
//    NSSortDescriptor *sortDescriptor;
//    
//    predicate = [NSPredicate predicateWithFormat:@"(confirmed = true) AND (start >= %@) AND (start < %@)", beginDate, endDate];
//    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
//    
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    [fetchRequest setPredicate:predicate];
//    
//    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    return results;

}

- (FeedEventEntity *)getFeedEventWithEventType:(int)eventType WithExtEventID:(NSString *)ext_event_id
{
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    
    int type = 0x00000001 << eventType;
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && ext_event_id=%@", type, ext_event_id];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([results count] > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (FeedEventEntity *)getDeletedICalFeedEventWithExtEventID:(NSString *)ext_event_id
{
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    
    int type = 0x00000001 << 5;
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && ext_event_id=%@", type, ext_event_id];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([results count] > 0)
    {
        return [results objectAtIndex:0];
    }
    return nil;
}

- (NSArray *)getFeedEventsWithEventType:(int)eventType WithID:(int)id WithLimit:(int)limit
{
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    int type = 0x00000001 << eventType;
    //predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && ext_event_id=%@", type, ext_event_id];
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && id=%@", type, @(id)];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:limit];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSAssert([results count]<=limit,@"fetch data error");
    if ([results count] > 0)
    {
        return results;
    }
    return nil;
}

- (NSArray *)getFeedEventsWithEventType:(int)eventType WithHasModified:(BOOL)hasModified
{
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    int type = 0x00000001 << eventType;
    //predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && ext_event_id=%@", type, ext_event_id];
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && hasModified=%@ && id!=0", type, @(hasModified)];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if ([results count] > 0)
    {
        return results;
    }
    return nil;
}

- (NSArray *)getDeletediCalFeedEvents
{
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    int type = 0x00000001 << 5;
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0 && hasDeleted=%@", type, @(YES)];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return results;
}
- (NSArray *)getAlliCalFeedEvent
{
    if (!managedObjectContext)
    {
        return nil ;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"eventType==5"];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return results;
}
-(DataCache *) getCache
{
    return cache;
}


-(NSArray*) getFeedEvents:(NSString *) day  evenTypeFilter:(int) filter;
{
//    NSLog(@"getFeedEvents,day=%@, filter=%d", day, filter);
//    
//    DayFeedEventEntitysWrap * wrap = [cache getDayFeedEventEntitysWrap:day];
//    
//    if(wrap != nil) {
//        if(wrap.eventTypeFilter != filter) {
//            wrap.eventTypeFilter = filter;
//            [wrap resetSortedEvents];
//        }
//        return wrap.sortedEvents;
//    } 
//    
//    NSDate * date = [Utils parseNSStringDay:day];
//
//    
//    NSArray * entitys = [self getFeedEventEntitys:date];
//    
//    wrap = [[DayFeedEventEntitysWrap alloc] init:day andFeedEvents:entitys];
//
//    wrap.eventTypeFilter = filter;
//    [wrap resetSortedEvents];
//    
//    return wrap.sortedEvents;
    
     NSDate * date = [Utils parseNSStringDay:day];
     NSArray * entitys = [self getFeedEventEntitys:date];
     return entitys;
}


-(int) getFeedEventCountByStart:(NSDate *) start andEnd:(NSDate *) end;
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"( (confirmed = true) AND ((start >= %@) AND (start <= %@))  OR ((end >= %@) AND (end <= %@)) ) AND (eventType & %d)>0", start,  end, start,  end, FILTER_IMCOMPLETE];
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
    
    LOG_D(@"getDayFeedEventType：%@", day);
    
    NSTimeInterval beginTime = [NSDate timeIntervalSinceReferenceDate];
    
    
    NSDate * date = [Utils parseNSStringDay:day];
    NSDate * beginDate = [[[date cc_dateByMovingToFirstDayOfTheMonth] cc_dateByMovingToThePreviousDayCout:7] cc_dateByMovingToBeginningOfDay];
    NSDate * endDate = [[date cc_dateByMovingToTheFollowingDayCout:40] cc_dateByMovingToEndOfDay];
    

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
  
    fetchRequest.propertiesToFetch = [NSArray arrayWithObjects:[[entity propertiesByName] objectForKey:@"start"], [[entity propertiesByName] objectForKey:@"eventType"], nil];
    
    fetchRequest.resultType = NSDictionaryResultType;
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(confirmed = true AND start >= %@ AND start < %@)", beginDate, endDate];
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(start != NULL)"];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for(NSDictionary * dic in results) {
        
        NSDate * date = [dic objectForKey:@"start"];
        NSString * eventDay = [Utils formateDay:date];
        int type = [[dic objectForKey:@"eventType"] intValue];
        
        wrap = [cache getDayEventTypeWrap:eventDay];
        if(wrap == nil) {
            wrap = [[DayEventTypeWrap alloc] init];
            wrap.day = eventDay;
            wrap.eventType = 0;
            [cache putDayEventTypeWrap:wrap];
        }
        
        int eventType = wrap.eventType;
        
         /*
         Calvin: 0
         Google Personal: 1
         Google work: 2
         Fackbook: 3
         Birthdays: 4
         iOSCalendar: 5
         */
        switch (type) {
            case 0:
                eventType |= FILTER_IMCOMPLETE;
                break;
                
            case 1:
            case 2:
                eventType |= FILTER_GOOGLE;
                break;
                
            case 3:
                eventType |= FILTER_FB;
                break;
                
            case 4:
                eventType |= FILTER_BIRTHDAY;
                break;
                
            case 5:
                eventType |= FILTER_IOS;
                break;
                
            default:
                break;
        }
        
        wrap.eventType = eventType;
    }
    
    //Fill the cache if a day no any event
    NSDate * begin = beginDate;
    while ( [begin compare:endDate] < 0) {
        
        NSString * aDay = [Utils formateDay:begin];
        wrap = [cache getDayEventTypeWrap:aDay];
        if(wrap == nil) {
            wrap = [[DayEventTypeWrap alloc] init];
            wrap.day = aDay;
            wrap.eventType = 0;
            [cache putDayEventTypeWrap:wrap];
        }
        
        begin = [begin cc_dateByMovingToTheFollowingDayCout:1];
    }
    
    wrap = [cache getDayEventTypeWrap:day];
    
    LOG_D(@"getDayFeedEventType: Time:%f", ([NSDate timeIntervalSinceReferenceDate] - beginTime));
    return wrap.eventType;
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
    if (!managedObjectContext)
    {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id = %d)", contactid];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:20];
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

-(NSArray *) queryContactEntity:(NSString *) prefix  andOffset:(NSInteger) offset
{
    NSDate * begin = [NSDate date];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if(prefix != nil) {
        NSString * queryStr = [NSString stringWithFormat:@"(email != '') AND ((first_name LIKE[c] '*%@*') OR (last_name LIKE[c] '*%@*') OR (email LIKE[c] '*%@*'))", prefix, prefix, prefix];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:queryStr];
        [fetchRequest setPredicate:predicate];
    } else {
        NSString * queryStr = [NSString stringWithFormat:@"(email != '')"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:queryStr];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor * sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"lastest_timestamp" ascending:NO];
    NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"fullname" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];
    
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:50];

    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    LOG_D(@"queryContactEntity time=%d", (int)([[NSDate date] timeIntervalSinceDate:begin]));
    return results;
}

-(NSArray *) getLimitContactEntity:(int)offset
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [fetchRequest setFetchOffset:offset*20];
    [fetchRequest setFetchLimit:20];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (ContactEntity *) getContactEntityWith:(NSString *) phone AndEmail:(NSString *)email
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(phone = %@ AND email = %@)", phone, email];
    [fetchRequest setPredicate:predicate];
    
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    if(results.count >0)
    {
        return [results objectAtIndex:0];
    }
    
    return nil;
}


- (ContactEntity *) getContactEntityWithEmail:(NSString *)email
{
    @synchronized(self) {

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactEntity" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email = %@)", email];
        [fetchRequest setPredicate:predicate];
        
        NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if(results.count >0)
        {
            return [results objectAtIndex:0];
        }
        
        return nil;
    }
}

- (void)deleteContactEntityWith:(NSString *)phone andEmail:(NSString *)email
{
    if (!managedObjectContext)
    {
        return;
    }
    
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
    if([managedObjectContext hasChanges]) {
       [managedObjectContext save:nil];
    }
}

+(CoreDataModel *) getInstance
{
    if(instance == nil) {
        instance = [[CoreDataModel alloc] init];
    }
    return instance;
}

//========================================Test=====================================//
- (void)getFeedEventWithEventType:(int)eventType
{
    if (!managedObjectContext)
    {
        return ;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedEventEntity" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate;
    
    int type = 0x00000001 << eventType;
    predicate = [NSPredicate predicateWithFormat:@"(eventType & %d)>0", type];
    [fetchRequest setPredicate:predicate];
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for (FeedEventEntity *tmp in results)
    {
        LOG_D(@"eventtype:%@ id:%@ ext_eveit_id:%@ last_modified:%@ start_day:%@ hasModified:%@ belongToiCal:%@",tmp.eventType,tmp.id,tmp.ext_event_id,tmp.last_modified,tmp.start,tmp.hasModified,tmp.belongToiCal);
    
    }
   
}


@end
