//
//  Utils.h
//  calender
//
//  Created by xiangfang on 13-5-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface Utils : NSObject

+(NSDate *) parseNSDate:(NSString*) strDate;


+(NSString *) formateStringDate:(NSString *) strDate;


//"HH:mm:ss"
+(NSString *) formateTime:(NSDate *) time;

+(NSString *) formateDay:(NSDate *) time;

+(NSString *) formateDate:(NSDate *) time;


+(NSMutableArray *) getEventSectionArray: (NSArray*)events;

//NSString -> NSMutableArray<Event>
+(NSMutableDictionary *) getEventSectionDict: (NSArray*)events;


+ (NSString *) convertObj2Json:(id)classInstance;

+(NSString *) dictionary2String:(NSDictionary *) dict;

+(NSMutableURLRequest *) createHttpRequest:(NSString *) url andMethod:(NSString *) methood;


@end
