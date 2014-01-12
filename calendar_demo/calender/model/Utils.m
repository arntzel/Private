
#import "Utils.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import <objc/message.h>

static NSTimeZone * userTimeZone;

@implementation Utils

+(void) setUserTimeZone:(NSTimeZone *) timezone
{
    userTimeZone = timezone;
}

+(NSDate *) getCurrentDate
{
    NSDate * date = [NSDate date];
    NSTimeZone * systemzone = [NSTimeZone systemTimeZone];
    int interval = [userTimeZone secondsFromGMT] - [systemzone secondsFromGMT];
    NSDate * time = [date  dateByAddingTimeInterval:interval];
    return time;
}

+(NSDate *) convertFromLocalDatetoUserDate:(NSDate *) localDate
{
    NSTimeZone * systemzone = [NSTimeZone systemTimeZone];
    int interval = [userTimeZone secondsFromGMT] - [systemzone secondsFromGMT];
    NSDate * time = [localDate  dateByAddingTimeInterval:interval];
    return time;
}

+(NSDate *) convertLocalDate:(NSDate *) gmtDate
{
    NSInteger interval = [userTimeZone secondsFromGMT];
    NSDate * localeDate = [gmtDate  dateByAddingTimeInterval:interval];
    return localeDate;
}

+(NSDate *) convertGMTDate:(NSDate *) localDate
{
    NSInteger interval = [userTimeZone secondsFromGMT];
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
 
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [format setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate * date =[format dateFromString:strDate];
    
    //NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    //NSDate * gmtDate = [date dateByAddingTimeInterval:interval];
    
    return date;
}

+(NSString *) formateTime:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"HH:mm:ss"];


    return [dateFormatter stringFromDate:time];
}

+(NSString *) formateMonthOnly:(NSDate *) month
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"MMM"];
    
    
    return [dateFormatter stringFromDate:month];
}

+(NSString *) formateTimeAMPM:(NSDate *) time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"h:mma"];

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

+(NSString *) formateDay3:(NSDate *) time
{
    //cccc
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMMM d'TH'"];


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
    NSDate * currentDate = [Utils getCurrentDate];
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
    
    NSDate *date = [self parseNSStringDay:day];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"EEEE,MMM d"];
    
    return [dateFormatter stringFromDate:date];
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
    
    NSTimeInterval interval = [time timeIntervalSinceNow] + [[NSTimeZone systemTimeZone] secondsFromGMT];
    
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


+(UIAlertView *) showUIAlertView:(NSString *) title andMessage:(NSString *) msg andDeletegate:(id) delegate
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:title
                                                    message:msg
                                                   delegate:delegate
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
    return alert;
}

+(UIAlertView *) showUIAlertView:(NSString *) title andMessage:(NSString *) msg
{
    return [Utils showUIAlertView:title andMessage:msg andDeletegate:nil];
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
    NSString * startTime = [Utils formateTimeAMPM: ps.start];
    
    if(ps.is_all_day) {
        
        NSString * duration;
        if(ps.duration_days<=1) {
            duration = @"All day";
        } else {
            duration = [NSString stringWithFormat:@"%ddays", ps.duration_days];
        }
        
        NSString * lable = [NSString stringWithFormat:@"%@ <font name=\"Avenir Next Bold\" size=\"12\">(duration:%@)</font> ", startTime, duration];
        return lable;
        
    } else {
        NSString * endTime = [Utils formateTimeAMPM: [ps getEndTime]];
        NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
        return lable;
    }
}

+(NSString *) getProposeStatLabel2:(ProposeStart *) ps
{
    NSString * startTime = [Utils formateTimeAMPM: ps.start];
    
    if(ps.is_all_day) {
        
        NSString * duration;
        if(ps.duration_days<=1) {
            duration = @"All day";
        } else {
            duration = [NSString stringWithFormat:@"%ddays", ps.duration_days];
        }
        
        NSString * lable = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%@</font>", duration];
        return lable;
        
    } else {
        if ([ps.start_type isEqualToString:START_TYPEEXACTLYAT]) {
            
            NSString *duration = [Utils formateTimeAMPM: ps.getEndTime];
            NSString *formattedStartTime = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%@</font> to <font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%@</font>", startTime, duration];
            return formattedStartTime;
        }
        //    else if ([ps.start_type isEqualToString:START_TYPEAFTER]){
        //        NSString *formattedStartTime = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%@</font>", startTime];
        //        return formattedStartTime;
        //    }
        else{
            NSString * duration = [ps parseDuringDateString2];
            NSString *formattedStartTime = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%@</font> for ", startTime];
            return [formattedStartTime stringByAppendingString:duration];
        }
    }
    
   
    
//    if(ps.is_all_day) {
//        
//        NSString * duration;
//        if(ps.duration_days<=1) {
//            duration = @"All day";
//        } else {
//            duration = [NSString stringWithFormat:@"%ddays", ps.duration_days];
//        }
//        
//        NSString * lable = [NSString stringWithFormat:@"%@ <font name=\"Avenir Next Bold\" size=\"12\">(duration:%@)</font> ", startTime, duration];
//        return lable;
//        
//    } else {
//        
//        NSString * endTime = [Utils formateTimeAMPM: [Utils convertLocalDate:[ps getEndTime]]];
//        NSString * lable = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
//        return lable;
//    }
}
@end
