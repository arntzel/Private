
#import <Foundation/Foundation.h>
#import "User.h"

@interface EventAttendee : NSObject

@property int id;
@property int archived;
@property int send;

@property(strong) NSString * status;

@property(strong) NSString * distinction;

@property(strong) NSString * suggest_end_datetime;
@property(strong) NSString * suggest_location;
@property(strong) NSString * suggest_start_datetime;

@property(strong) User * user;

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json;

@end
