
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
    
    if(lastupdatetime == nil) {
        NSDate * begin = [Utils getCurrentDate];
        lastupdatetime = [begin cc_dateByMovingToFirstDayOfThePreviousMonth];
    };
    
    
    [self setSynchronizeData:YES];
    LOG_D(@"synchronizedFromServer begin :%@", lastupdatetime);
    [[Model getInstance] getUpdatedEvents:lastupdatetime andOffset:0 andCallback:^(NSInteger error, NSInteger count, NSArray *events) {
        
        LOG_D(@"synchronizedFromServer end, %@ , error=%d, count:%d, allcount:%d", lastupdatetime, error, events.count, count);

        [self setSynchronizeData:NO];
        
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
        
        [model saveData];
        [[UserSetting getInstance] saveLastUpdatedTime:maxlastupdatetime];
        [model notifyModelChange];
        
        if(events.count < count) {
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
    NSDate * lastmodify = nil;
    if(setting != nil) {
        lastmodify = [Utils parseNSDate:setting.value];
    }
    
    synchronizingContactData = YES;
    [[UserModel getInstance] getMyContacts:lastmodify limit:100 andCallback:^(NSInteger error, int totalCount, NSArray * contacts) {
        synchronizingContactData = NO;
        
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
            
            NSString * updateTime = [Utils formateDate:maxlatmodify];
            [model saveSetting:KEY_CONTACTUPDATETIME andValue:updateTime];
            
            
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
@end
