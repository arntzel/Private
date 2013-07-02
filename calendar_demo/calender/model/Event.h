

#import <Foundation/Foundation.h>
#import "User.h"
#import "Location.h"
#import "EventAttendee.h"

/*

 */
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
