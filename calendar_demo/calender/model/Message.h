
#import <Foundation/Foundation.h>
#import "User.h"


@interface Message : NSObject

@property int id;

@property NSString * subject;

@property NSString * email;

@property NSString * body;


@property NSDate * moderation_date;

@property NSString * moderation_reason;

@property NSString * moderation_status;

@property NSDate * read_at;



@property User * recipient;

@property BOOL recipient_archived;

@property NSDate * replied_at;


@property User * sender;

@property BOOL sender_archived;

@property NSDate * sender_deleted_at;

@property NSDate * sent_at;

+(Message *) parseMSeesage:(NSDictionary *) json;

@end
