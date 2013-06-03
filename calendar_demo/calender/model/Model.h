
#import <Foundation/Foundation.h>
#import "User.h"
#import "Event.h"
#import "Message.h"
#import "Buddy.h"

@interface Model : NSObject


/**
 Call WebService API to get the lastest events.s
 */
-(void) getEvents:(void (^)(NSInteger error, NSArray* events))callback;


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


/*
 Get the single instance of Model object
 */
+(Model *) getInstance;


@end
