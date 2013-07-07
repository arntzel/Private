
#import <Foundation/Foundation.h>
#import "EventModel.h"
#import "User.h"
#import "Event.h"
#import "Message.h"
#import "Buddy.h"


typedef NS_ENUM(NSInteger, ERROCODE) {
    ERROCODE_OK = 0,   //OK
    ERROCODE_NETWORK,  //network error
    ERROCODE_SERVER,   //server errir
    ERROCODE_UNAUTHORIZED, //unauthorized
};


/*
 All methods are called by UI thread, and return immediately.
 UI thread may received a notification though callback object when the asynchronous task done.
 */
@interface Model : NSObject


-(void) createEvent:(Event *) evt andCallback:(void (^)(NSInteger error, Event * newEvt))callback;


/**
 Call WebService API to get the lastest events.s
 NSArray* events: The Event object array
 */
-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;


-(void) getEvents:(int) year andMonth:(int) month andCallback:(void (^)(NSInteger error, NSArray* events))callback;

/*
 Get all pending events
 */
-(void) getEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback;

/*
 Get all pending events
 */
-(void) getRelativeEventsOfPending:(void (^)(NSInteger error, NSArray* events)) callback;

/**
 Call WebService API to Update event title and description
 */
-(void) updateEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback;

/**
 Call WebService API to Delete a event
 */
-(void) deleteEvent:(Event *) event andCallback:(void (^)(NSInteger error))callback;



/**
 Call WebService API to get messages with apikey
  NSArray* messages: The Message object array
 */
-(void) getMessages:(void (^)(NSInteger error, NSArray* messages))callback;


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


-(EventModel *) getEventModel;


/*
 Get the single instance of Model object
 */
+(Model *) getInstance;


@end
