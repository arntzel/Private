

#import <Foundation/Foundation.h>
#import "User.h"
#import "Location.h"

@interface Event : NSObject

@property int id;

@property NSString * eventImageUrl;

@property NSString * eventTitle;

@property NSString * attenedees;

@property User * host;

@property BOOL isAllDay;

@property NSDate * startTime;

@property int duration;

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


@property Location * location;

@end
