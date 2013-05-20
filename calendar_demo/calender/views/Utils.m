//
//  Utils.m
//  calender
//
//  Created by xiangfang on 13-5-11.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Utils.h"

@implementation Utils


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

        NSString * day = [Utils formateDay:event.startTime];

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

         NSString * day = [Utils formateDay:event.startTime];

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
