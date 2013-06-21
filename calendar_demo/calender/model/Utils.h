

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Utils : NSObject

/*
 convert a NSString to NSDate object
 strDate: the date of string format, example: "2013-06-02 12:12:10"
 return a NSDate object
 */
+(NSDate *) parseNSDate:(NSString*) strDate;


/*
 convert a NSDate to NSString object
 return the date of string format, example: "2013-06-02 12:12:10"
 */
+(NSString *) formateStringDate:(NSString *) strDate;


//"HH:mm:ss"

/*
 return the time part of the NSDate: example: "23:12:10"
 */
+(NSString *) formateTime:(NSDate *) time;

/*
 return the day part of the NDDate: example: "2013-06-02"
 */
+(NSString *) formateDay:(NSDate *) time;

+(NSString *) formate:(int) year andMonth:(int)month andDay:(int) day;

/*
 convert a NSDate to NSString object
 return the date of string format, example: "2013-06-02 12:12:10"
 */
+(NSString *) formateDate:(NSDate *) time;

/*
 convert a NSDate to NSString object
 return the date of string format, example: "2013-06"
 */
+(NSString *) formateMonth:(NSDate *) date;

/*
 convert  to NSString object
 return the date of string format, example: "2013-06"
 */
+(NSString *) formate:(int) year andMonth:(int)month;


/**
 return the date list that the events contained
 */
+(NSMutableArray *) getEventSectionArray: (NSArray*)events;

/*
 NSString -> NSMutableArray<Event>
  group the events by the date
 */
+(NSMutableDictionary *) getEventSectionDict: (NSArray*)events;


/*
 convert a object to a NSString object of json format.
 */
+ (NSString *) convertObj2Json:(id)classInstance;

/*
 convert a NSDictionary object to a NSString object of json format.
 */
+(NSString *) dictionary2String:(NSDictionary *) dict;

/*
 Create a Http request object with url and method
 */
+(NSMutableURLRequest *) createHttpRequest:(NSString *) url andMethod:(NSString *) methood;


@end
