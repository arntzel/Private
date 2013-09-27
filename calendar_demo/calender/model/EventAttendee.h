
#import <Foundation/Foundation.h>
#import "User.h"

@interface EventAttendee : NSObject

@property int id;
@property int archived;
@property int send;
@property BOOL is_owner;

/*
 
 */
@property int status;

@property(strong) NSString * distinction;

@property(strong) NSString * suggest_end_datetime;
@property(strong) NSString * suggest_location;
@property(strong) NSString * suggest_start_datetime;

@property(strong) User * user;


-(NSDictionary*)convent2Dic;

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json;

@end
