
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
    
    NSDate * lastupdatetime = [[UserSetting getInstance] getLastUpdatedTime];
    int offset = [[UserSetting getInstance] getIntValue:KEY_LASTUPDATETIMEOFFSET];

    if(lastupdatetime == nil) {
        NSDate * begin = [Utils getCurrentDate];
        lastupdatetime = [begin cc_dateByMovingToFirstDayOfThePreviousMonth];
    };
    
    
    [self setSynchronizeData:YES];
    LOG_D(@"synchronizedFromServer begin :%@, offset=%d", lastupdatetime, offset);
    [[Model getInstance] getUpdatedEvents:lastupdatetime andOffset:offset andCallback:^(NSInteger error, NSInteger totalCount, NSArray *events) {
        
        LOG_D(@"synchronizedFromServer end, %@ , error=%d, count:%d， offset=%d, allcount:%d", lastupdatetime, error, events.count, offset, totalCount);

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
            return;
        }
        
        NSDate * maxlastupdatetime = lastupdatetime;
        
        CoreDataModel * model = [CoreDataModel getInstance];
        
        for(Event * evt in events) {
            
            
            if([evt.last_modified compare:maxlastupdatetime] > 0) {
                maxlastupdatetime = evt.last_modified;
            }
            
            FeedEventEntity * entity =[model getFeedEventEntity:evt.id];
            
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
        


        if([maxlastupdatetime isEqualToDate:lastupdatetime]) {
            int newoffset = offset + events.count;
            [[UserSetting getInstance] saveKey:KEY_LASTUPDATETIMEOFFSET andIntValue:newoffset];
        } else {
            [[UserSetting getInstance] saveLastUpdatedTime:maxlastupdatetime];
            [[UserSetting getInstance] saveKey:KEY_LASTUPDATETIMEOFFSET andIntValue:0];
        }

        [model saveData];
        [model notifyModelChange];
        
        if(events.count + offset < totalCount) {
            //还有数据没更新，继续从服务器拉取数据
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(synchronizedFromServer)
                                           userInfo:nil
                                            repeats:NO];
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

    Setting * setting = [[CoreDataModel getInstance] getSetting:KEY_CONTACTUPDATETIME];
    int offset = [[UserSetting getInstance] getIntValue:KEY_CONTACTUPDATETIMEOFFSET];

     NSDate * lastmodify = nil;
    if(setting != nil) {
        lastmodify = [Utils parseNSDate:setting.value];
    }
    
    synchronizingContactData = YES;
    [[UserModel getInstance] getMyContacts:lastmodify offset:offset andCallback:^(NSInteger error, int totalCount, NSArray * contacts) {
        synchronizingContactData = NO;
        if(![[UserModel getInstance] isLogined]) {
            return;
        }
        
        LOG_D(@"updateContacts end, %@ , error=%d, count:%d, offset=%d, allcount:%d", lastmodify, error, contacts.count, offset, totalCount);

        if(error == 0) {
            NSDate * maxlatmodify = lastmodify;
            
            if(contacts.count == 0) {
                LOG_D(@"updateContacts, no updated contact.");
                return;
            }
            
            CoreDataModel * model = [CoreDataModel getInstance];
            for(Contact * contact in contacts) {
                
                if(maxlatmodify == nil || [contact.modified compare:maxlatmodify] > 0) {
                    maxlatmodify = contact.modified;
                }
                
                ContactEntity * enity = [model getContactEntity:contact.id];
                if(enity == nil) {
                    enity = [model createEntity:@"ContactEntity"];
                }
                
                [enity convertContact:contact];
            }
            
            [model saveData];

            if(lastmodify == nil || ![maxlatmodify isEqualToDate:lastmodify]) {
                NSString * updateTime = [Utils formateDate:maxlatmodify];
                [model saveSetting:KEY_CONTACTUPDATETIME andValue:updateTime];
                [[UserSetting getInstance] saveKey:KEY_CONTACTUPDATETIMEOFFSET andIntValue:0];
            } else {

                NSString * updateTime = [Utils formateDate:maxlatmodify];
                [model saveSetting:KEY_CONTACTUPDATETIME andValue:updateTime];

                int newoffset = offset + contacts.count;
                [[UserSetting getInstance] saveKey:KEY_CONTACTUPDATETIMEOFFSET andIntValue:newoffset];
            }


            
            
            if(contacts.count + offset < totalCount) {
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
    [[Model getInstance]uploadEventsFromCalendarApp:^(NSInteger error, NSMutableArray *events) {
        NSLog(@"upload events from calendar app successed!");
        if (events != nil)
        {
            CoreDataModel * model = [CoreDataModel getInstance];
            for (Event *newEvent in events)
            {
                FeedEventEntity * entity = [model createEntity:@"FeedEventEntity"];
                [entity convertFromEvent:newEvent];
                [model addFeedEventEntity:entity];
            }
            [model saveData];
            [model notifyModelChange];
        }
        
    }];
}
@end
