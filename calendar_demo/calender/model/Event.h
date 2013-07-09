

#import <Foundation/Foundation.h>
#import "User.h"
#import "EventDate.h"
#import "Location.h"
#import "EventAttendee.h"


#define FILTER_IMCOMPLETE  0X00000001
#define FILTER_GOOGLE      0X00000002
#define FILTER_FB          0X00000008
#define FILTER_BIRTHDAY    0X00000010


/*
 exactly_at', _(u'Exactly at')),
 ('within_an_hour', _(u'Within an hour')),
 ('anytime_after', _(u'Anytime after')),

 */

//#define START_TYPEEXACTLYAT  @"exactly_at"
//#define START_TYPEWITHIN     @"within_an_hour"
//#define START_TYPEAFTER      @"anytime_after"
//define in EventDate.h

@interface Event : NSObject

@property int id;

@property BOOL allow_attendee_invite;
@property BOOL allow_new_dt;
@property BOOL allow_new_location;
@property BOOL archived;
@property BOOL is_all_day;
@property BOOL published;
@property BOOL confirmed;

@property(strong) NSDate * created_on;

@property(strong) User * creator;

@property(strong) NSString * description;

@property(strong) NSString * duration;
@property int duration_days;
@property int duration_hours;
@property int duration_minutes;

@property(strong) NSString * start_type;
@property(strong) NSDate * start;

@property(strong) NSDate * end;

@property(strong) Location * location;


@property(strong) NSDictionary * status;


@property(strong) NSString * thumbnail_url;
@property(strong) NSString * title;
@property(strong) NSString * userstatus;
@property(strong) NSString * timezone;

@property(strong) NSArray * attendees;


//Allow suggest new datetime  0
//Allow suggest new location  1
//Allow invitee invite others 2
@property int privilige;


/*
 Calvin: 0
 Google Personal: 1
 Google work: 2
 Fackbook: 3
 Birthdays: 4
 */
@property int eventType;


-(int) getPendingUserCount;

-(BOOL) isPendingStatus;


/*
 Parse Event object from json data.
 */
+(Event *) parseEvent:(NSDictionary *) json;

@end
