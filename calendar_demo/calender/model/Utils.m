
#import "Utils.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation Utils

+(NSDate *) parseNSDate:(NSString*) strDate
{
    if([strDate isKindOfClass:[NSNull class]]) {
       return nil;
    }

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

+(NSString *) formateTimeAMPM:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"K:mma"];

    return [dateFormatter stringFromDate:time];
}


+(NSString *) formateDay:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];


    return [dateFormatter stringFromDate:time];
}

+(NSString *) formate:(int) year andMonth:(int)month andDay:(int) day
{
    NSMutableString * str = [[NSMutableString alloc] init];
    
    [str appendFormat:@"%d-", year];
    
    if(month>9) {
        [str appendFormat:@"%d-", month];
    } else {
        [str appendFormat:@"0%d-", month];
    }
    
    if(day>9) {
        [str appendFormat:@"%d", day];
    } else {
        [str appendFormat:@"0%d", day];
    }
    
    return str;
}

+(NSString *) toReadableDay:(NSString *) day
{
    NSDate * currentDate = [NSDate date];
    NSString * today = [self formateDay:currentDate];
    NSString * tomorrom = [self formateDay:[currentDate dateByAddingTimeInterval:24*3600] ];
    NSString * yestoday = [self formateDay:[currentDate dateByAddingTimeInterval:-24*3600]];
    
    if( [day isEqualToString:today]) {
        return @"Today";
    } else if( [day isEqualToString:tomorrom]) {
        return @"Tomorrow";
    } else if( [day isEqualToString:yestoday]) {
        return @"Yestoday";
    }
    
    return day;
}


+(NSString *) formateDate:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

    return [dateFormatter stringFromDate:time];    
}

+(NSString *) formateMonth:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM"];

    return [dateFormatter stringFromDate:date];
}

+(NSString *) formate:(int) year andMonth:(int)month;
{
    if(month>9) {
        return [NSString stringWithFormat:@"%d-%d", year, month];
    } else {
        return [NSString stringWithFormat:@"%d-0%d", year, month];
    }
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

+ (NSString *) convertObj2Json:(id) classInstance
{

    Class clazz = [classInstance class];
    u_int count;

    objc_property_t * properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        id value =  [classInstance performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:@""];
        else {
            [valueArray addObject:value];
        }
    }
    
    free(properties);

    NSDictionary* dtoDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];

    return [Utils dictionary2String:dtoDic];
}

+(NSString *) dictionary2String:(NSDictionary *) dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return json;
}

+(NSMutableURLRequest *) createHttpRequest:(NSString *) strurl andMethod:(NSString *) methood
{
    NSURL * url = [NSURL URLWithString:strurl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:20];

    [request setHTTPMethod:methood];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return request;
}


+(NSString *) getAttendeeText:(Event*)event {
    
    NSArray * atendees = event.attendees;
    
    int respCount = 0;
    int allCount = atendees.count;
    
    for(int i=0;i<allCount;i++) {
        
        EventAttendee * atd = [atendees objectAtIndex:i];
        
        if([atd.status isEqualToString:@"ACCEPT"]) {
            respCount ++;
        }
    }
    
    return [NSString stringWithFormat:@"%d/%d invitees have responsed", respCount, allCount];
}

@end
