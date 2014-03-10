
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>  

#import "FeedEventEntityExtra.h"
#import "UserEntityExtra.h"
#import "MessageEntityExtra.h"
#import "ContactEntityExtra.h"
#import "Setting.h"

#import "DataCache.h"

typedef enum
{
    EventChangeType_Add,
    EventChangeType_Delete,
    EventChangeType_Update,
    EventChangeType_Finalize,
    EventChangeType_Unfinalize
    
} EventChangeType;

@protocol CoreDataModelDelegate <NSObject>
    -(void) onCoreDataModelStarted;
    -(void) onCoreDataModelChanged;
    -(void) onEventChanged:(FeedEventEntity *) event andTpe:(EventChangeType) type;
@end

@protocol PopDelegate <NSObject>
    -(void) onControlledPopped:(BOOL)dataChanged;
@end


@interface CoreDataModel : NSObject


@property BOOL inited;

-(void) initDBContext:(User *) user;

-(void) addDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) removeDelegate:(id<CoreDataModelDelegate>) delegate;

-(void) notifyModelChange;

-(void) notifyEventChange:(FeedEventEntity *) entity andChangeTyp:(EventChangeType) type;


-(DataCache *) getCache;


-(NSArray *) getPendingFeedEventEntitys;


//GMT date: 获取从一段时间内的所有event
-(NSArray *) getDayFeedEventEntitys:(NSDate *) begin andEndDate:(NSDate *) end;


-(FeedEventEntity*) getFeedEventEntity:(int) id;

/**
 *  get the Contacts that are never uploaded to server
 *
 *  @param contactid 0 represents the contact is not upload to server.
 *
 *  @return the Contancts Array which are not upload to server.
 */
-(NSArray *) getContactEntitysWithID:(int) contactid;


-(NSArray *) getContactEntitysByIDs:(NSString *) ids;


/**
 *  get the event from Calendar App.
 *
 *  @param eventType    5 represents the events from Calendar App.
 *  @param ext_event_id unique id.
 *
 *  @return the event.
 */
- (FeedEventEntity *)getFeedEventWithEventType:(int)eventType WithExtEventID:(NSString *)ext_event_id;
- (FeedEventEntity *)getDeletedICalFeedEventWithExtEventID:(NSString *)ext_event_id;
- (NSArray *)getFeedEventsWithEventType:(int)eventType WithID:(int)id WithLimit:(int)limit;
- (NSArray *)getFeedEventsWithEventType:(int)eventType WithHasModified:(BOOL)hasModified;
- (NSArray *)getDeletediCalFeedEvents;
- (NSArray *)getAlliCalFeedEvent;


//GMT date
-(int) getFeedEventCountByStart:(NSDate *) start andEnd:(NSDate *) end;



//user date
-(int) getDayFeedEventType:(NSString *) day;


-(void) addFeedEventEntitys:(NSArray *) entitys;

-(void) addFeedEventEntity:(FeedEventEntity*) entity;

-(void) updateFeedEventEntity:(FeedEventEntity*) entity;


-(void) deleteFeedEventEntity:(int) eventID;

-(void) deleteFeedEventEntity2:(FeedEventEntity *) entity;

//Begin for Message notification
-(int) getMessageCount;

-(MessageEntity *) getMessage:(int) offset;

-(MessageEntity *) getMessageByID:(int) msgID;
//End for Message notification


-(ContactEntity *) getContactEntity:(int) contactid;
/**
 *  get contact entity with phone and email
 *
 *  @param phone
 *  @param email
 *
 *  @return ContactEntity
 */
//- (ContactEntity *) getContactEntityWith:(NSString *) phone AndEmail:(NSString *)email;

- (ContactEntity *) getContactEntityWithEmail:(NSString *)email;


-(NSArray *) getAllContactEntity;

-(NSArray *) queryContactEntity:(NSString *) prefix andOffset:(NSInteger) offset;

-(NSArray *) getLimitContactEntity:(int)offset;
- (void)deleteContactEntityWith:(NSString *)phone andEmail:(NSString *)email;

-(Setting *) getSetting:(NSString *) key;

-(void) saveSetting:(NSString *) key andValue:(NSString *) value;



-(id) createEntity:(NSString *) entityName;

-(void) deleteEntity:(NSManagedObject *) entity;

-(void) saveData;


+(CoreDataModel *) getInstance;


-(void) reset;
//========================================Test=====================================//
- (void)getFeedEventWithEventType:(int)eventType;
@end
