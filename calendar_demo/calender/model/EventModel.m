
#import "EventModel.h"
#import "Utils.h"
#import "Model.h"
#import "CoreDataModel.h"
#import "UserSetting.h"
#import "UserModel.h"
#import "UserSetting.h"
#import "NSDateAdditions.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventModel {

    BOOL synchronizingContactData;
    
    NSMutableArray * delegates;
}

-(id) init {
    self = [super init];

    delegates = [[NSMutableArray alloc] init];
    return self;
}

-(void) addDelegate:(id<EventModelDelegate>) delegate
{
    [delegates addObject:delegate];
}

-(void) removeDelegate:(id<EventModelDelegate>) delegate
{
    [delegates removeObject:delegate];
}

-(void) nofityModelChanged:(BOOL) loading
{
    for(id<EventModelDelegate> delegate in delegates) {
        [delegate onEventModelChanged:loading];
    }
}

-(void) notifyUserAccountChanged
{
    for(id<EventModelDelegate> delegate in delegates) {
        
        if([delegate respondsToSelector:@selector(onUserAccountChanged)]) {
            [delegate onUserAccountChanged];
        }
    }
}

-(void) notifyEventFiltersChanged
{
    for(id<EventModelDelegate> delegate in delegates) {
        
        if([delegate respondsToSelector:@selector(onEventFiltersChanged)]) {
            [delegate onEventFiltersChanged];
        }
    }
}

-(void) downloadServerEvents:(int) unused onComplete:(void(^)(NSInteger success, NSInteger totalCount))completion
{
    assert([[UserModel getInstance] isLogined]);
    
    NSLog(@"synchronizedFromServer begin");
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_LASTUPDATETIME];
    if(last_modify_num == nil) {
        last_modify_num = [self getSecondsFromEpoch];
    }
    
    LOG_D(@"synchronizedFromServer begin :%@", last_modify_num);
    [[Model getInstance] getUpdatedEvents:last_modify_num andCallback:^(NSInteger error, NSInteger totalCount, NSArray *events) {
        
        LOG_D(@"synchronizedFromServer end, %@ , error=%d, count:%d, allcount:%d", last_modify_num, error, events.count, totalCount);
        
        if (error) {
            if (completion) {
                completion(NO,totalCount);
            }
            return;
        }
        
        if (events.count == 0) {
            LOG_D(@"synchronizedFromServer, no updated event");
            
            if (completion) {
                completion(NO,totalCount);
            }
            return;
        }
        
        NSString * maxlastupdatetime = last_modify_num;
        
        CoreDataModel * model = [CoreDataModel getInstance];
        NSLog(@"========before download=========");
    //    [model getFeedEventWithEventType:5];
        for(Event * evt in events) {
            
            if([evt.modified_num compare:maxlastupdatetime] > 0) {
                maxlastupdatetime = evt.modified_num;
            }
            
            FeedEventEntity * entity =[model getFeedEventEntity:evt.id];
            
            if(entity == nil && evt.eventType == 5) {
                entity = [model getFeedEventWithEventType:evt.eventType WithExtEventID:evt.ext_event_id];
            }
            
            if(evt.confirmed && [evt isDeclineEvent]) {
                if(entity != nil) {
                    LOG_I(@"deleteFeedEventEntity2:%d, %@", evt.id, evt.title);
                    [model deleteFeedEventEntity2:entity];
                }
                
            } else {
                
                if(entity == nil) {
                    entity = [model createEntity:@"FeedEventEntity"];
                } else {
                    for(UserEntity * user in entity.attendees) {
                        [model deleteEntity:user];
                    }
                    
                    [entity clearAttendee];
                }
                
                [entity convertFromEvent:evt];
                [model updateFeedEventEntity:entity];
            }
        }

        [[UserSetting getInstance] saveKey:KEY_LASTUPDATETIME andStringValue:maxlastupdatetime];
        
        [model saveData];
        
        NSLog(@"========after download=========");
       // [model getFeedEventWithEventType:5];
        
        [model notifyModelChange];
        
        if(events.count < totalCount) {
            
            //next page - test some more please
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), queue, ^{

                [self downloadServerEvents:unused onComplete:completion];
            });
        }
        else
        {
            if (completion) {
                completion(NO,totalCount);
            }
        }
    }];
}

-(void) checkContactUpdate
{
    if(![[UserModel getInstance] isLogined]) {
        return;
    }

    if(synchronizingContactData) return;
    
    [self updateContacts];
}

-(void) updateContacts
{
    LOG_D(@"updateContacts");
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_CONTACTUPDATETIME];
    if(last_modify_num == nil) {
        last_modify_num = [self getSecondsFromEpoch];
    }
    
    synchronizingContactData = YES;
    [[UserModel getInstance] getMyContacts:last_modify_num andCallback:^(NSInteger error, int totalCount, NSArray * contacts) {
        synchronizingContactData = NO;
        if(![[UserModel getInstance] isLogined]) {
            return;
        }
        
        LOG_D(@"updateContacts end, %@ , error=%d, count:%d, allcount:%d", last_modify_num, error, contacts.count, totalCount);

        if(error == 0) {
            
            NSString * maxlatmodify = last_modify_num;
            
            if(contacts.count == 0) {
                LOG_D(@"updateContacts, no updated contact.");
                return;
            }
            
            //Contact是否有被更新的数据
            bool contactsupdated = NO;
            
            CoreDataModel * model = [CoreDataModel getInstance];
            for(Contact * contact in contacts) {
                
                if(maxlatmodify == nil || [contact.modified_num compare:maxlatmodify] > 0) {
                    maxlatmodify = contact.modified_num;
                }
                
                ContactEntity * enity = [model getContactEntityWith:contact.phone AndEmail:contact.email];
                if(enity == nil) {
                    enity = [model createEntity:@"ContactEntity"];
                    LOG_D(@"Create new Contact[ %d, %@ ]", contact.id, contact.email);
                } else {
                    
                    LOG_D(@"Update Contact[%d, %@ ]", contact.id, contact.email);
                    contactsupdated = YES;
                }
                
                [enity convertContact:contact];
            }
            
            [model saveData];

            [[UserSetting getInstance] saveKey:KEY_CONTACTUPDATETIME andStringValue:maxlatmodify];            

            if(contactsupdated) {
                LOG_D(@"Contact updated");
                [[CoreDataModel getInstance] notifyModelChange];
            }
            
            
            if(contacts.count < totalCount) {
                //还有数据没更新，继续从服务器拉取数据
                [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(checkContactUpdate)
                                               userInfo:nil
                                                repeats:NO];

            }
        }
    }];
}

-(void) updateEventsFromLocalDevice:(int) unused onComplete:(void(^)(NSInteger success, NSInteger totalCount))completion
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[Model getInstance] getEventsFromCalendarApp:^(NSMutableArray *allEvents) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            BOOL success = NO;
            
            if (allEvents != nil)
            {
                success = YES;
                
                CoreDataModel * model = [CoreDataModel getInstance];
                NSMutableArray *allICalEventsInDB = [NSMutableArray arrayWithArray:[model getAlliCalFeedEvent]];
                
                for (Event *tmp in allEvents)
                {
                    for (FeedEventEntity *iCalEventInDB in allICalEventsInDB)
                    {
                        if ([tmp.ext_event_id isEqualToString:iCalEventInDB.ext_event_id])
                        {
                            [allICalEventsInDB removeObject:iCalEventInDB];
                            break;
                        }
                    }
                }
                
                for (FeedEventEntity *iCalEventInDB in allICalEventsInDB)
                {
                    LOG_D(@"have %d event(s) has been deleted!!!",[allICalEventsInDB count]);
                    FeedEventEntity *eventEntity = [model getFeedEventWithEventType:5 WithExtEventID:iCalEventInDB.ext_event_id];
                    eventEntity.hasDeleted = @(YES);
                }
                for (Event *event1 in allEvents)
                {
                    FeedEventEntity *eventEntity = [model getFeedEventWithEventType:5 WithExtEventID:event1.ext_event_id];
                    if (eventEntity)
                    {
                        NSTimeInterval entitySec = (int)[eventEntity.last_modified timeIntervalSince1970];
                        NSTimeInterval eventSec = (int)[event1.last_modified timeIntervalSince1970];
                        if (entitySec < eventSec)
                        {
                            
                            NSNumber *tmpID = eventEntity.id;
                            
                            [eventEntity convertFromCalendarEvent:event1];
                            eventEntity.id = tmpID;
                            eventEntity.hasModified = @(YES);
                            //新加属性 belongToiCal，因无须同步到服务器，所以不在convertFromCalendarEvent:方法中封装，如果
                            //封装则可能从服务器获得空值。
                            eventEntity.belongToiCal = event1.belongToiCal;
                            [model updateFeedEventEntity:eventEntity];
                        }
                    }
                    else
                    {
                        FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                        [entity convertFromCalendarEvent:event1];
                        entity.belongToiCal = event1.belongToiCal;
                        [model updateFeedEventEntity:entity];
                    }
                }
                
                [model saveData];
                
                //[model getFeedEventWithEventType:5];
                //[model notifyModelChange];
            }
            
            if (completion) {
                completion(success, [allEvents count]);
            }
            });
        }];
    });
}


-(void) checkSettingUpdate
{
    if (![[UserModel getInstance] isLogined]) {
        return;
    }
    
    [[UserModel getInstance] getSetting:^(NSInteger error, NSDictionary *settings) {
        
        if(error == 0) {
            
            NSArray * show_notification_types = nil;
            if ([[settings objectForKey:@"show_notification_types"] isKindOfClass:[NSArray class]])
            {
                show_notification_types = [settings objectForKey:@"show_notification_types"];
            }
            
            NSMutableString * strNotiTypes = [[NSMutableString alloc] init];
            
            for(int i=0 ; i<show_notification_types.count; i++) {
                [strNotiTypes appendString:[NSString stringWithFormat:@"%@",[show_notification_types objectAtIndex:i]]];
                
                if(i<show_notification_types.count-1) {
                    [strNotiTypes appendString:@","];
                }
            }
            
            NSString * Notistr = [[UserSetting getInstance] getStringValue:KEY_SHOW_NOTIFICATION_TYPES];
            
            if(Notistr == nil || ![Notistr isEqualToString:strNotiTypes]) {
                [[UserSetting getInstance] saveKey:KEY_SHOW_NOTIFICATION_TYPES andStringValue:strNotiTypes];
                LOG_I(@"saveKey: %@=%@", KEY_SHOW_NOTIFICATION_TYPES, strNotiTypes);
            }
            
            
            NSString * show_event_types = [settings objectForKey:@"show_event_types"];
            int filters = 0;
            if(show_event_types == nil)
            {
                filters = FILTER_IMCOMPLETE | FILTER_GOOGLE | FILTER_FB | FILTER_GOOGLE | FILTER_IOS;
                
            } else {
                
                NSRange range;
                range.length = 1;
                
                for(int i=0 ; i<show_event_types.length/2; i++) {
                    range.location = i*2;
                    int eventType = [[show_event_types substringWithRange:range] intValue];
                    filters |= (0x01 << eventType);
                }
            }
            
            int localFilter = [[UserSetting getInstance] getEventfilters];
            if(localFilter != filters)
            {
                [[UserSetting getInstance] saveEventfilters:filters];
                [[[Model getInstance] getEventModel] notifyEventFiltersChanged];
            }
        }
    }];
}

- (void)updateEventsFromCalendarApp
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[Model getInstance] getEventsFromCalendarApp:^(NSMutableArray *allEvents) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (allEvents != nil)
                {
                    CoreDataModel * model = [CoreDataModel getInstance];
                    NSMutableArray *allICalEventsInDB = [NSMutableArray arrayWithArray:[model getAlliCalFeedEvent]];

                    for (Event *tmp in allEvents)
                    {
                        for (FeedEventEntity *iCalEventInDB in allICalEventsInDB)
                        {
                            if ([tmp.ext_event_id isEqualToString:iCalEventInDB.ext_event_id])
                            {
                                [allICalEventsInDB removeObject:iCalEventInDB];
                                break;
                            }
                        }
                    }
                    
                    for (FeedEventEntity *iCalEventInDB in allICalEventsInDB)
                    {
                        LOG_D(@"have %d event(s) has been deleted!!!",[allICalEventsInDB count]);
                        FeedEventEntity *eventEntity = [model getFeedEventWithEventType:5 WithExtEventID:iCalEventInDB.ext_event_id];
                        eventEntity.hasDeleted = @(YES);
                    }
                    for (Event *event1 in allEvents)
                    {
                        FeedEventEntity *eventEntity = [model getFeedEventWithEventType:5 WithExtEventID:event1.ext_event_id];
                        if (eventEntity)
                        {
                            NSTimeInterval entitySec = (int)[eventEntity.last_modified timeIntervalSince1970];
                            NSTimeInterval eventSec = (int)[event1.last_modified timeIntervalSince1970];
                            if (entitySec < eventSec)
                            {
                                
                                NSNumber *tmpID = eventEntity.id;
                                
                                [eventEntity convertFromCalendarEvent:event1];
                                eventEntity.id = tmpID;
                                eventEntity.hasModified = @(YES);
                                //新加属性 belongToiCal，因无须同步到服务器，所以不在convertFromCalendarEvent:方法中封装，如果
                                //封装则可能从服务器获得空值。
                                eventEntity.belongToiCal = event1.belongToiCal;
                                [model updateFeedEventEntity:eventEntity];
                            }
                        }
                        else
                        {
                            FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                            [entity convertFromCalendarEvent:event1];
                            entity.belongToiCal = event1.belongToiCal;
                            [model updateFeedEventEntity:entity];
                        }
                        
                    }
                    
                    [model saveData];
                    
                    //[model getFeedEventWithEventType:5];
                    [model notifyModelChange];
                }
                
                for(id<EventModelDelegate> delegate in delegates)
                {
                    //[delegate onSynchronizeDataCompleted];
                }
            });
        }];
    });
}

- (void)uploadCalendarEvents
{
    if(![[UserModel getInstance] isLogined])
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CoreDataModel * model = [CoreDataModel getInstance];
        NSArray *arrFromDB = [model getFeedEventsWithEventType:5 WithID:0 WithLimit:40];
        if (arrFromDB!=nil && [arrFromDB count]>0)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [[Model getInstance] uploadEventsFromCalendarApp:[NSMutableArray arrayWithArray:arrFromDB] callback:^(NSInteger error, NSMutableArray *respEvents) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (respEvents && [respEvents count]>0)
                        {
                           
                            for (Event *respEvent in respEvents)
                            {
                                //change the event id after uploading ical data.
                                FeedEventEntity * oldEntity = [model getFeedEventWithEventType:5 WithExtEventID:respEvent.ext_event_id];
                                [oldEntity convertFromCalendarEvent:respEvent];
                                [model updateFeedEventEntity:oldEntity];
                                
                                
                            }
                            [model saveData];
                        }
                        
                    });
                }];
            });
        }
        else
        {
            [self modifyCalendarEventsFromServer];
        }
    });
}

- (void)modifyCalendarEventsFromServer
{
    if(![[UserModel getInstance] isLogined])
    {
        return;
    }
    CoreDataModel * model = [CoreDataModel getInstance];
    NSArray *arrFromDB = [model getFeedEventsWithEventType:5 WithHasModified:YES];
    if (arrFromDB!=nil && [arrFromDB count]>0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            FeedEventEntity *entity = [arrFromDB objectAtIndex:0];
            [[Model getInstance] modifyICalEventWithEventEntity:entity callback:^(NSInteger error, Event *modifiedEvent) {
                
                NSLog(@"modifyEvent.title:%@",modifiedEvent.title);
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    FeedEventEntity * oldEntity = [model getFeedEventWithEventType:5 WithExtEventID:modifiedEvent.ext_event_id];
                    [oldEntity convertFromCalendarEvent:modifiedEvent];
                    oldEntity.hasModified = NO;
                    [model saveData];
                });
                
            }];
            
        });
        
    }
}

- (void)deleteIcalEvent
{
    if(![[UserModel getInstance] isLogined])
    {
        return;
    }
    CoreDataModel * model = [CoreDataModel getInstance];
    NSMutableArray *deletedIcalEvents = [NSMutableArray arrayWithArray:[model getDeletediCalFeedEvents]];
    for (int i=0;i<[deletedIcalEvents count];i++)
    {
        FeedEventEntity *deletedIcalEvent = [deletedIcalEvents objectAtIndex:i];
        if ([deletedIcalEvent.id intValue]==0)
        {
            LOG_D(@"delete the ical events whoes id is 0");
            [model deleteFeedEventEntity:0];
            [deletedIcalEvents removeObject:deletedIcalEvent];
        }
    }
    if ([deletedIcalEvents count]>0)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            FeedEventEntity *entity = [deletedIcalEvents objectAtIndex:0];
            [[Model getInstance] deleteICalEventWithEventEntity:entity callback:^(NSInteger error) {
                if (error == 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        [model deleteFeedEventEntity:[entity.id intValue]];
                        [self deleteIcalEvent];
                    });
                }
            }];
        });
    }
    else
    {
        [self uploadCalendarEvents];
    }
}


- (void)uploadContacts
{
    assert([[UserModel getInstance] isLogined]);
    
    CoreDataModel * model = [CoreDataModel getInstance];
    
    NSMutableArray *neverUploadedContactsArray = [NSMutableArray arrayWithArray:[model getContactEntitysWithID:0]];
    
    if ([neverUploadedContactsArray count] <= 0) {
        return;
    }
    
    [[UserModel getInstance] uploadAddressBookContacts:neverUploadedContactsArray callback:^(NSInteger error, NSArray *respContacts) {
        
        if (respContacts && [respContacts count]>0)
        {
            CoreDataModel * model = [CoreDataModel getInstance];
            for(Contact * contact in respContacts)
            {
                ContactEntity *enity = [model getContactEntityWith:contact.phone AndEmail:contact.email];
                if (enity)
                {
                    [enity convertContact:contact];
                }
            }
            [model saveData];
        }
    }];
}

- (void)uploadContacts000
{
    assert([[UserModel getInstance] isLogined]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CoreDataModel * model = [CoreDataModel getInstance];
        
        NSMutableArray *neverUploadedContactsArray = [NSMutableArray arrayWithArray:[model getContactEntitysWithID:0]];
        
            [[UserModel getInstance] uploadAddressBookContacts:neverUploadedContactsArray callback:^(NSInteger error, NSArray *respContacts) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (respContacts && [respContacts count]>0)
                    {
                        CoreDataModel * model = [CoreDataModel getInstance];
                        for(Contact * contact in respContacts)
                        {
                            ContactEntity *   enity = [model getContactEntityWith:contact.phone AndEmail:contact.email];
                            if (enity)
                            {
                                [enity convertContact:contact];
                            }
                        }
                        [model saveData];
                    }
                });
                
            }];
        });
    //});
}

-(NSString *) getSecondsFromEpoch
{
    NSDate * now = [NSDate date];
    
    NSDate * start = [now dateByAddingTimeInterval:-2*30*24*3600];
    start = [start cc_dateByMovingToFirstDayOfThePreviousMonth];
    
    double seconds = [start timeIntervalSince1970];
    
    NSString * str = [NSString stringWithFormat:@"%lf", seconds];
    return str;
}


@end
