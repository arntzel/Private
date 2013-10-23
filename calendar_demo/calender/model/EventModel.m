
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
        
        LOG_D(@"synchronizedFromServer end, %@ , error=%d, count:%d, allcount:%d", last_modify_num, error, events.count, totalCount);

        [self setSynchronizeData:NO];
        
        if(![[UserModel getInstance] isLogined]) {
            return;
        }
        
        if(error != 0) {
            
            for(id<EventModelDelegate> delegate in delegates) {
                [delegate onSynchronizeDataError:error];
            }
            
            return;
        }
        
        if(events.count == 0) {
            LOG_D(@"synchronizedFromServer, no updated event");
            for(id<EventModelDelegate> delegate in delegates) {
                [delegate onSynchronizeDataCompleted];
            }
            return;
        }
        
        NSString * maxlastupdatetime = last_modify_num;
        
        CoreDataModel * model = [CoreDataModel getInstance];
        
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
        [model notifyModelChange];
        
        if(events.count < totalCount) {
            //还有数据没更新，继续从服务器拉取数据
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(synchronizedFromServer)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            
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
//    [[Model getInstance]uploadEventsFromCalendarApp:^(NSInteger error, NSMutableArray *events) {
//        NSLog(@"upload events from calendar app successed!");
//        if (events != nil)
//        {
//            CoreDataModel * model = [CoreDataModel getInstance];
//            for (Event *newEvent in events)
//            {
//                FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
//                [entity convertFromEvent:newEvent];
//                [model addFeedEventEntity:entity];
//            }
//            [model saveData];
//            [model notifyModelChange];
//        }
//        
//    }];
//    [[Model getInstance]getEventsFromCalendarApp:^(NSMutableArray *modifiedEvents, NSMutableArray *newEvents) {
//        
//        CoreDataModel * model = [CoreDataModel getInstance];
//        for (Event *newEvent in newEvents)
//        {
//            FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
//            [entity convertFromEvent:newEvent];
//            [model addFeedEventEntity:entity];
//        }
//        for (Event *modifiedEvent in modifiedEvents)
//        {
//            FeedEventEntity * oldEntity = [[FeedEventEntity alloc] init] ;
//            [oldEntity convertFromEvent:modifiedEvent];
//            [model deleteFeedEventEntity2:oldEntity];
//            FeedEventEntity * newEntity = [model createEntity:@"FeedEventEntity"];
//            [newEntity convertFromEvent:modifiedEvent];
//            [model addFeedEventEntity:newEntity];
//        }
//        [model saveData];
//        //[[Model getInstance] uploadEventsFromCalendarApp:newEvents];
//        //[[Model getInstance] updateEventsFromCalendarApp:modifiedEvents];
//    }];
    [[Model getInstance] getEventsFromCalendarApp:^(NSMutableArray *allEvents) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableArray *newEvents = [NSMutableArray array];
            NSMutableArray *modifiedEvents = [NSMutableArray array];
            CoreDataModel * model = [CoreDataModel getInstance];
            for (Event *event1 in allEvents)
            {
                FeedEventEntity *eventEntity = [model getFeedEventWithEventType:5 WithExtEventID:event1.ext_event_id];
                if (eventEntity)
                {
                    LOG_D(@"eventEntity.created_on:%@  event1.created_on:%@",eventEntity.created_on,event1.created_on);
                    if ([eventEntity.created_on compare:event1.created_on] != NSOrderedSame)
                    {
                        [modifiedEvents addObject:event1];
                    }
                }
                else
                {
                    [newEvents addObject:event1];
                }
                
            }
            for (Event *newEvent in newEvents)
            {
                FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                [entity convertFromCalendarEvent:newEvent];
                [model addFeedEventEntity:entity];
            }
            for (Event *modifiedEvent in modifiedEvents)
            {
                FeedEventEntity * oldEntity = [model getFeedEventWithEventType:5 WithExtEventID:modifiedEvent.ext_event_id];
                [oldEntity convertFromCalendarEvent:modifiedEvent];
                [model deleteFeedEventEntity2:oldEntity];
                [model addFeedEventEntity:oldEntity];
            }
            [model saveData];
            [model notifyModelChange];
            
            
        });
        
    }];
}

- (void)uploadContacts
{
    if(![[UserModel getInstance] isLogined])
    {
        return;
    }
    CoreDataModel * model = [CoreDataModel getInstance];
    NSMutableArray *neverUploadedContactsArray = [NSMutableArray arrayWithArray:[model getContactEntitysWithID:0]];
    [[UserModel getInstance] uploadAddressBookContacts:neverUploadedContactsArray callback:^(NSInteger error, NSArray *respContacts) {
        
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
    }];
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
