
#import <Foundation/Foundation.h>
#import "Contact.h"

@interface EventAttendee : NSObject

@property int id;

@property BOOL is_owner;

@property int status;

@property(strong) Contact * contact;



-(NSDictionary*)convent2Dic;

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json;

@end
