
#import "EventModel.h"
#import "Utils.h"
#import "Model.h"
#import "CoreDataModel.h"
#import "UserSetting.h"
#import "UserModel.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EventModel {

    BOOL synchronizingData;

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
    synchronizingData = loading;
    [self nofityModelChanged];
}

-(void) synchronizedFromServer
{
    if (![[UserModel getInstance] isLogined]) {
        return;
    }
    
    if([self isSynchronizeData]) return;
    
    NSLog(@"synchronizedFromServer begin");
    
    NSDate * lastupdatetime = [[UserSetting getInstance] getLastUpdatedTime];
    
    if(lastupdatetime == nil) return;
    
    
    [self setSynchronizeData:YES];
    
    NSDate * currentTime = [NSDate date];
    
    [[Model getInstance] getUpdatedEvents:lastupdatetime andOffset:0 andCallback:^(NSInteger error, NSInteger count, NSArray *events) {
        
        [self setSynchronizeData:NO];
        
        LOG_D(@"synchronizedFromServer begin end, updated event count:%d", events.count);

        if(events.count > 0) {
           
            CoreDataModel * model = [CoreDataModel getInstance];
            
            for(Event * evt in events) {
                
                FeedEventEntity * entity =[model getFeedEventEntity:evt.id];
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
            
            [model saveData];
            [model notifyModelChange];
        }
        
        [[UserSetting getInstance] saveLastUpdatedTime:currentTime];
    }];
}


@end
