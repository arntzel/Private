
#import <Foundation/Foundation.h>
#import "EventModel.h"
#import "MessageModel.h"

#import "User.h"
#import "Event.h"
#import "Message.h"
#import "Buddy.h"
#import "Comment.h"
#import "FeedEventEntity.h"
#import "ASIFormDataRequest.h"

typedef NS_ENUM(NSInteger, ERROCODE) {
    ERROCODE_OK = 0,   //OK
    ERROCODE_NETWORK,  //network error
    ERROCODE_SERVER,   //server errir
    ERROCODE_UNAUTHORIZED, //unauthorized
    ERROCODE_EVENT_NOTEXITED,
};


@protocol UploadImageDelegate <NSObject>

-(void) onUploadStart;

-(void) onUploadProgress: (long long) progress andSize: (long long) Size;

-(void) onUploadCompleted: (int) error andUrl:(NSString *) url;

@end


/*
 All methods are called by UI thread, and return immediately.
 UI thread may received a notification though callback object when the asynchronous task done.
 */
@interface Model : NSObject


-(void) createEvent:(Event *) evt andCallback:(void (^)(NSInteger error, Event * newEvt))callback;

-(void)getEventsFromCalendarApp:(void (^)(NSMutableArray * allEvents))callback;
- (void)uploadEventsFromCalendarApp:(NSMutableArray *)newEvents callback:(void (^)(NSInteger error, NSMutableArray * respEvents))callback;
- (void)modifyICalEventWithEventEntity:(FeedEventEntity *)eventEntity callback:(void (^)(NSInteger error, Event * modifiedEvent))callback;
- (void)deleteICalEventWithEventEntity:(FeedEventEntity *)eventEntity callback:(void (^)(NSInteger error))callback;

-(void) getEvent:(int) eventID andCallback:(void (^)(NSInteger error, Event * event))callback;


/**
 Call WebService API to get the lastest events.s
 NSArray* events: The Event object array
 */
//-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;


//-(void) getEvents:(int) year andMonth:(int) month andCallback:(void (^)(NSInteger error, NSArray* events))callback;

//-(void) getEventsOfBegin:(NSDate *) begin andOffset:(int) offset andEventType:(NSString *) eventType andCallback:(void (^)(NSInteger error, NSInteger count, NSArray* events))callback;


-(void) getUpdatedEvents:(NSString *) modified_num andCallback:(void (^)(NSInteger error, NSInteger count, NSArray* events))callback;


//-(void) getEventsOfBegin:(NSDate *) begin andEnd:(NSDate*) end andCallback:(void (^)(NSInteger error, NSArray* events))callback;


//-(void) getEventsOfDay:(NSDate *) day andCallback:(void (^)(NSInteger error, NSArray* events))callback;


/*
 Get all pending events
 */
//-(void) getEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback;

/*
 Get all pending events
 */
//-(void) getRelativeEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback;

/**
 Call WebService API to Update event title and description
 */
-(void) updateEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback;

/**
 Call WebService API to Delete a event
 */
-(void) deleteEvent:(int) eventID andCallback:(void (^)(NSInteger error))callback;


-(void) getUnreadMessages:(void (^)(NSInteger error, NSArray* messages))callback;


-(void) readMessage:(int) msgID andCallback:(void (^)(NSInteger error, int msgID))callback;


-(void) readAllMessage: (void (^)(NSInteger error))callback;


/**
 Call WebService API to get messages with apikey
  NSArray* messages: The Message object array
 */
-(void) getMessages:(void (^)(NSInteger error, NSArray* messages))callback;


-(void) getMessages:(int) offset andCallback :(void (^)(NSInteger error, NSArray* messages))callback;


/**
 Call WebService API to update messages with apikey
 */
-(void) updateMessage:(Message *) msg andCallback:(void (^)(NSInteger error))callback;

/**
 Call WebService API to delete a message with apikey
 */
-(void) deleteMessage:(Message *) msg andCallback:(void (^)(NSInteger error))callback;



/**
 Call WebService API to get buddy with apikey
  NSArray* buddies: the Buddy object array
 */
-(void) getBuddies:(void (^)(NSInteger error, NSArray* buddies))callback;


/**
 Call WebService API to delete a buddy with apikey
 */
-(void) deleteBuddy:(Buddy *) buddy andCallback:(void (^)(NSInteger error))callback;


/**
 Call WebService API to create a buddy with apikey
 */
-(void) createBuddy:(Buddy *) buddy andCallback:(void (^)(NSInteger error))callback;


-(ASIFormDataRequest *) uploadImage:(UIImage *) img andCallback:(id<UploadImageDelegate>)delegate;


-(void) updateMessageReadStatus: (void (^)(NSInteger error))callback;






-(void) getEventComment:(int) eventID Offset:(int)offset Limit:(int)limit andCallback:(void (^)(NSInteger error, NSArray * comments))callback;

-(void) createComment:(Comment *) cmt andCallback:(void (^)(NSInteger error, Comment * cmt))callback;



///////////////////////////////////////////////////////////////////////////////////////////////////////////
//For EventTimeVote

-(void) updateVote:(EventTimeVote *) vote andproposeStartID:(int) proposeStartID andCallback:(void (^)(NSInteger error))callback;

-(void) createVote:(int) proposeStartID andVoteStatus:(int) status andCallback:(void (^)(NSInteger error, int voteID))callback;

-(void) createProposeStart:(Event *) event andPropose:(ProposeStart *) proposeStat andCallback:(void (^)(NSInteger error, ProposeStart * proposeStat))callback;

-(void) deleteProposeStart:(int) proposeStatID andCallback:(void (^)(NSInteger error))callback;

-(void) finalizeProposeStart:(int) eventID ProposeStart:(ProposeStart *) proposeStart andCallback:(void (^)(NSInteger error, Event * event))callback;



-(void) updateLocation:(int) eventID Location:(Location *) location andCallback:(void (^)(NSInteger error))callback;

-(void) updateEventAttendeeStatus:(int) atdID andInviteeKey:(NSString *) invite_key andStatus:(int) status andCallback:(void (^)(NSInteger error))callback;

-(void) updateEventPhoto:(int) eventID PhotoUrl:(NSString *) url andCallback:(void (^)(NSInteger error))callback;

//Invitee list
-(void) inviteContacts:(int) eventID andContact:(NSArray *) invitees andCallback:(void (^)(NSInteger error, Event * newEvent))callback;


-(void) getLatestVersion:(void (^)(NSInteger error, NSDictionary * dic))callback;



-(EventModel *) getEventModel;

-(MessageModel *) getMessageModel;

/*
 Get the single instance of Model object
 */
+(Model *) getInstance;


@end
