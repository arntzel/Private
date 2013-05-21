

#import <Foundation/Foundation.h>
#import "User.h"
#import "Location.h"

@interface Event : NSObject

@property int id;

@property BOOL allow_attendee_invite;
@property BOOL allow_new_dt;
@property BOOL allow_new_location;
@property BOOL archived;
@property BOOL is_all_day;
@property BOOL published;

@property NSDate * created_on;

@property User * creator;

@property NSString * description;

@property int duration_days;
@property int duration_hours;
@property int duration_minutes;

@property NSString * start_type;
@property NSDate * start;

@property NSDate * end;

@property Location * location;


@property NSDictionary * status;


@property NSString * thumbnail_url;
@property NSString * title;
@property NSString * userstatus;

@property NSArray * attendees;


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


+(Event *) parseEvent:(NSDictionary *) json;

@end
