
#import <Foundation/Foundation.h>
#import "User.h"


@interface Message : NSObject

@property int id;

@property(strong) NSString * subject;

@property(strong) NSString * email;

@property(strong) NSString * body;


@property(strong) NSDate * moderation_date;

@property(strong) NSString * moderation_reason;

@property(strong) NSString * moderation_status;

@property(strong) NSDate * read_at;



@property(strong) User * recipient;

@property BOOL recipient_archived;

@property(strong) NSDate * replied_at;


@property(strong) User * sender;

@property BOOL sender_archived;

@property(strong) NSDate * sender_deleted_at;

@property(strong) NSDate * sent_at;


/*
 Parse Message object from json data.
 */
+(Message *) parseMSeesage:(NSDictionary *) json;

@end
