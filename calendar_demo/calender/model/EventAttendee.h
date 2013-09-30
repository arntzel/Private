
#import <Foundation/Foundation.h>
#import "Contact.h"

@interface EventAttendee : NSObject

@property int id;

@property BOOL is_owner;

/*
 (-1, _(u'Declined')),
 (0, _(u'Added')),
 (1, _(u'Sent')),
 (2, _(u'Opened')),
 (3, _(u'Responded')),
 */
@property int status;

@property(strong) Contact * contact;



-(NSDictionary*)convent2Dic;

+(EventAttendee *) parseEventAttendee:(NSDictionary *) json;

@end
