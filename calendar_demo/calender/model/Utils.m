
#import "Utils.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Utils

+(NSDate *) convertLocalDate:(NSDate *) gmtDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: gmtDate];
    
    NSDate * localeDate = [gmtDate  dateByAddingTimeInterval:interval];
    
    return localeDate;
}

+(NSDate *) convertGMTDate:(NSDate *) localDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: localDate];

    NSDate * gmtDate = [localDate  dateByAddingTimeInterval:-interval];

    return gmtDate;
}


+(NSDate *) convertGMTDate:(NSDate *) date andTimezone:(NSTimeZone *) tinezone
{
    NSInteger interval = [tinezone secondsFromGMTForDate:date];
    NSDate * gmtDate = [date  dateByAddingTimeInterval:-interval];
    return gmtDate;
}

+(NSDate *) gmtDate2LocatDate:(NSDate *) gmtdate andTimezone:(NSTimeZone *) tinezone
{
    if(gmtdate == nil) {
        return nil;
    }
        
    
    NSInteger interval = [tinezone secondsFromGMTForDate:gmtdate];
    NSDate * date = [gmtdate  dateByAddingTimeInterval:interval];
    return date;
}

+(NSDate *) parseNSDate:(NSString*) strDate
{
    if(strDate == nil || [strDate isKindOfClass:[NSNull class]]) {
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

+(NSString *) formateDay2:(NSDate *) time
{
    //cccc
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"cccc MMMM d'TH'"];


    return [dateFormatter stringFromDate:time];
}

+(NSDate *) parseNSStringDay:(NSString *) strDay
{
    NSRange range;
    range.location = 0;
    range.length = 4;
    
    int year = [[strDay substringWithRange:range] intValue];
    
    range.location = 5;
    range.length = 2;
    int month = [[strDay substringWithRange:range] intValue];
    
    range.location = 8;
    range.length = 2;
    int day = [[strDay substringWithRange:range] intValue];
    
    
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = day;
    c.month = month;
    c.year = year;
    return [[NSCalendar currentCalendar] dateFromComponents:c];
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

+(NSString *) formateDate: (NSDate *) time andTimezone:(NSTimeZone *) timezone
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone =  timezone;
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss ZZZ"];
    
    return [dateFormatter stringFromDate:time];

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

+(NSString *) getTimeText:(NSDate *) time
{
    NSTimeInterval interval = [time timeIntervalSinceNow];
    
    int ago = -1*interval/60;
    
    if(ago < 1) {
        return @"now";
    }
    
    if(ago <= 60) {
        return [NSString stringWithFormat:@"%d mins ago", ago];
    }
    
    int hour = ago/60;
    if(hour <= 24) {
        return [NSString stringWithFormat:@"%d hours ago", hour];
    }
    
    int day = hour/24;
    
    if (day<=5) {
        return [NSString stringWithFormat:@"%d days ago", day];
    }
    
    return [Utils formateDay:time];
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
        id value = objc_msgSend(classInstance, NSSelectorFromString([NSString stringWithUTF8String:propertyName]));
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
    [request setTimeoutInterval:30];

    [request setHTTPMethod:methood];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return request;
}


+(NSString *) getAttendeeText:(FeedEventEntity*)event {
    
    //NSArray * atendees = event.attendees;
    
    int respCount = 0;
    int allCount = event.attendees.count;
    
    
    for(UserEntity * entity in event.attendees) {
        
        if([[entity is_owner] boolValue]) {
            respCount++;
            continue;
        }
        
        if([entity.status intValue] == 3 || [entity.status intValue] == -1) {
            respCount ++;
        }
    }
    
    return [NSString stringWithFormat:@"%d/%d invitees have responsed", respCount, allCount];
}


+(void) showUIAlertView:(NSString *) title andMessage:(NSString *) msg
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];

    [alert show];

}

+(id) chekcNullClass:(id) obj
{
    if([obj isKindOfClass: [NSNull class]]) {
        return nil;
    } else {
        return obj;
    }
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidatePhoneNumber:(NSString *) phoneNUmber
{
    NSString *regex =  @"^(\\d{3,4}-)\\d{7,8}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regex];
    return [emailTest evaluateWithObject:phoneNUmber];
}

+(NSString *) getProposeStatLabel:(ProposeStart *) ps
{
    NSString * startTime = [Utils formateTimeAMPM: [Utils convertLocalDate:ps.start]];
    NSString * endTime = [Utils formateTimeAMPM: [Utils convertLocalDate:[ps getEndTime]]];
    NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    return lable;
}
@end
