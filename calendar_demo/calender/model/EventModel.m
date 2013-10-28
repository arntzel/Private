
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

    BOOL synchronizingData;

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

-(void) nofityModelChanged
{
    for(id<EventModelDelegate> delegate in delegates) {
        [delegate onEventModelChanged:synchronizingData];
    }
}

-(BOOL) isSynchronizeData
{
    return synchronizingData;
}

-(void) setSynchronizeData:(BOOL) loading
{
    if(synchronizingData != loading) {
        synchronizingData = loading;
        [self nofityModelChanged];
    }
}

-(void) synchronizedFromServer
{
    
    if (![[UserModel getInstance] isLogined]) {
        return;
    }
    
    if([self isSynchronizeData]) return;
    NSLog(@"synchronizedFromServer begin");
    
    NSString * last_modify_num = [[UserSetting getInstance] getStringValue:KEY_LASTUPDATETIME];
    if(last_modify_num == nil) {
        last_modify_num = [self getSecondsFromEpoch];
    }
    
    [self setSynchronizeData:YES];
    LOG_D(@"synchronizedFromServer begin :%@", last_modify_num);
    [[Model getInstance] getUpdatedEvents:last_modify_num andCallback:^(NSInteger error, NSInteger totalCount, NSArray *events) {
        
        [self setSynchronizeData:NO];
        LOG_D(@"synchronizedFromServer end, %@ , error=%d, count:%d, allcount:%d", last_modify_num, error, events.count, totalCount);

       
        
        if(![[UserModel getInstance] isLogined]) {
            [self setSynchronizeData:NO];
            return;
        }
        
        if(error != 0) {
            
//            for(id<EventModelDelegate> delegate in delegates) {
//                [delegate onSynchronizeDataError:error];
//            }
            [self updateEventsFromCalendarApp];
            return;
        }
        
        if(events.count == 0) {
            LOG_D(@"synchronizedFromServer, no updated event");
            [self updateEventsFromCalendarApp];
           
            return;
        }
        
        NSString * maxlastupdatetime = last_modify_num;
        
        CoreDataModel * model = [CoreDataModel getInstance];
        NSLog(@"========before download=========");
        [model getFeedEventWithEventType:5];
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
        [model getFeedEventWithEventType:5];
        
        [model notifyModelChange];
        
        if(events.count < totalCount) {
            //还有数据没更新，继续从服务器拉取数据
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(synchronizedFromServer)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            
            //[self updateEventsFromCalendarApp];
            
            for(id<EventModelDelegate> delegate in delegates) {
                [delegate onSynchronizeDataCompleted];
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
                
                ContactEntity * enity = [model getContactEntity:contact.id];
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

- (void)updateEventsFromCalendarApp
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[Model getInstance] getEventsFromCalendarApp:^(NSMutableArray *allEvents) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (allEvents==nil || [allEvents count]==0)
                {
                    
                }
                else
                {
                    CoreDataModel * model = [CoreDataModel getInstance];
                    NSLog(@"========before get event from iCal=========");
                    [model getFeedEventWithEventType:5];
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
                                [model updateFeedEventEntity:eventEntity];
                            }
                        }
                        else
                        {
                            FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                            [entity convertFromCalendarEvent:event1];
                            [model updateFeedEventEntity:entity];
                        }
                        
                    }
                    
                    [model saveData];
                    [model notifyModelChange];
                }
                
                for(id<EventModelDelegate> delegate in delegates)
                {
                    [delegate onSynchronizeDataCompleted];
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
                            LOG_D(@"================ finish uploading events =============");
                            
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
    [model getFeedEventWithEventType:5];
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
- (void)uploadContacts
{
    if(![[UserModel getInstance] isLogined])
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CoreDataModel * model = [CoreDataModel getInstance];
        NSMutableArray *neverUploadedContactsArray = [NSMutableArray arrayWithArray:[model getContactEntitysWithID:0]];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[UserModel getInstance] uploadAddressBookContacts:neverUploadedContactsArray callback:^(NSInteger error, NSArray *respContacts) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (respContacts && [respContacts count]>0)
                    {
                        CoreDataModel * model = [CoreDataModel getInstance];
                        for(Contact * contact in respContacts)
                        {
                            LOG_D(@"contact.email:%@",contact.email);
                            LOG_D(@"contact.phone:%@",contact.phone);
                            [model deleteContactEntityWith:contact.phone andEmail:contact.email];
                            ContactEntity *   enity = [model createEntity:@"ContactEntity"];
                            [enity convertContact:contact];
                        }
                        
                        [model saveData];
                    }
                });
                
            }];
        });
        
    });
    
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
