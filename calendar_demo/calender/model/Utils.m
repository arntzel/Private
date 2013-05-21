//
//  Utils.m
//  calender
//
//  Created by xiangfang on 13-5-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSDate *) parseNSDate:(NSString*) strDate
{
    strDate = [Utils formateStringDate:strDate];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date =[format dateFromString:strDate];
    return date;
}



+(NSString *) formateStringDate:(NSString *) strDate
{
    strDate = [strDate substringToIndex:19];

    NSMutableString * sDate = [NSMutableString stringWithString:strDate];
    NSRange range;
    range.location = 10;
    range.length = 1;

    [sDate replaceCharactersInRange:range withString:@" "];
    return sDate;
}



+(NSString *) formateTime:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];


    return [dateFormatter stringFromDate:time];
}


+(NSString *) formateDay:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy:MM:dd"];


    return [dateFormatter stringFromDate:time];
}

+(NSMutableArray *) getEventSectionArray: (NSArray*)events
{
    NSMutableArray * array = [[NSMutableArray alloc] init];

    for(int i=0;i<events.count;i++) {
        Event * event = [events objectAtIndex:i];

        NSString * day = [Utils formateDay:event.created_on];

        if(![array containsObject:day]) {
            [array addObject:day];
        }
    }

    return array;
}


+(NSMutableDictionary *) getEventSectionDict: (NSArray*)events
{
     NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];

     for(int i=0;i<events.count;i++) {
         Event * event = [events objectAtIndex:i];

         NSString * day = [Utils formateDay:event.created_on];

         NSMutableArray * array = [dict objectForKey:day];

         if(array == nil) {
             array = [[NSMutableArray alloc] init];
             [dict setObject:array forKey:day];
         }

         [array addObject:event];
     }

    return dict;
}

@end
