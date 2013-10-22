

#import <Foundation/Foundation.h>
#import "User.h"
#import "ProposeStart.h"
#import "Location.h"
#import "EventAttendee.h"
#import "ProposeStart.h"
#import "Invitee.h"

#define FILTER_IMCOMPLETE  0X00000001
#define FILTER_GOOGLE      0X00000002
#define FILTER_FB          0X00000008
#define FILTER_BIRTHDAY    0X00000010
#define FILTER_IOS         0X00000020



//#define START_TYPEEXACTLYAT  @"exactly_at"
//#define START_TYPEWITHIN     @"within_an_hour"
//#define START_TYPEAFTER      @"anytime_after"
//define in EventDate.h

@interface Event : NSObject

@property int id;

@property BOOL allow_attendee_invite;
@property BOOL allow_new_dt;
@property BOOL allow_new_location;

@property BOOL all_responded;

@property BOOL archived;
@property BOOL is_all_day;
@property BOOL published;
@property BOOL confirmed;

@property(strong) NSDate * created_on;
@property(strong) NSDate * last_modified;
@property(strong) User * creator;


@property(strong) NSString * duration;
@property int duration_days;
@property int duration_hours;
@property int duration_minutes;

/*
 exactly_at', _(u'Exactly at')),
 ('within_an_hour', _(u'Within an hour')),
 ('anytime_after', _(u'Anytime after')),
 */
@property(strong) NSString * start_type;

//may be nil
@property(strong) NSDate * start;

@property(strong) NSDate * end;

@property(strong) Location * location;


@property(strong) NSDictionary * status;


@property(strong) NSString * thumbnail_url;
@property(strong) NSString * title;
@property(strong) NSString * description;
@property BOOL userstatus;
@property(strong) NSString * timezone;


//Only for create events
//Invitee List
@property(strong) NSArray * invitees;

//EventAttendee list
@property(strong) NSArray * attendees;

//ProposeStart list
@property(strong) NSArray * propose_starts;

@property (nonatomic, strong) NSString *ext_event_id;

/*
 Calvin: 0
 Google Personal: 1
 Google work: 2
 Fackbook: 3
 Birthdays: 4
 iOSCalendar: 5
 */
@property int eventType;


-(BOOL) isDeclineEvent;


-(ProposeStart *) getFinalEventTime;


-(NSDate *) getEndTime;

//Emai -> EventAttendee
-(NSDictionary *) getAttendeesDic;


-(NSDictionary*)convent2Dic;


/*
 Parse Event object from json data.
 */
+(Event *) parseEvent:(NSDictionary *) json;

@end
