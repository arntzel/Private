//
//  ProposeStart.m
//  Calvin
//
//  Created by xiangfang on 13-9-23.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "ProposeStart.h"
#import "Utils.h"

@implementation ProposeStart

-(NSDate *) getEndTime
{
    int durationSeconds =  self.duration_minutes*60 + self.duration_hours*3600 + self.duration_days*3600*24;
    return [self.start dateByAddingTimeInterval:durationSeconds];
}

-(NSDictionary*) convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    if(self.id > 0) {
        [dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];
    }

    [dic setObject:[Utils formateDate:self.start] forKey:@"start"];
    [dic setObject:self.start_type forKey:@"start_type"];

    [dic setObject:[NSNumber numberWithBool:self.is_all_day] forKey:@"is_all_day"];
    [dic setObject:[NSNumber numberWithInt:self.duration_days] forKey:@"duration_days"];
    [dic setObject:[NSNumber numberWithInt:self.duration_hours] forKey:@"duration_hours"];
    [dic setObject:[NSNumber numberWithInt:self.duration_minutes] forKey:@"duration_minutes"];
    
    
    NSMutableArray * voteJsons = [[NSMutableArray alloc] init];

    for(EventTimeVote * vote in self.votes)
    {
        [voteJsons addObject:[vote convent2Dic]];
    }

    [dic setObject:voteJsons forKey:@"vote"];
    return dic;

}

+(ProposeStart *) parse:(NSDictionary *) json
{

    ProposeStart * start = [[ProposeStart alloc] init];
    start.id = [[json objectForKey:@"id"] intValue];
    start.start = [Utils parseNSDate:[json objectForKey:@"start"]];
    start.start_type = [json objectForKey:@"start_type"];

    
    NSNumber * num = [Utils chekcNullClass:[json objectForKey:@"is_all_day"]];
    if(num != nil) {
        start.is_all_day = [num boolValue];
    }
    
    num = [Utils chekcNullClass:[json objectForKey:@"duration_days"]];
    if(num != nil) {
        start.duration_days = [num boolValue];
    }
    
    num = [Utils chekcNullClass:[json objectForKey:@"duration_hours"]];
    if(num != nil) {
        start.duration_hours = [num boolValue];
    }
    
    num = [Utils chekcNullClass:[json objectForKey:@"duration_minutes"]];
    if(num != nil) {
        start.duration_minutes = [num boolValue];
    }
    
    
    NSArray *  voteJsons = [json objectForKey:@"vote"];

    NSMutableArray * votes = [[NSMutableArray alloc] init];
    for(NSDictionary * voteJson in voteJsons) {
        EventTimeVote * vote = [EventTimeVote parse:voteJson];
        [votes addObject:vote];
    }

    start.votes = votes;
    return  start;
}




- (id)copyWithZone:(NSZone *)zone
{
    ProposeStart *newDate = [[ProposeStart alloc] init];
    newDate.id = self.id;

    newDate.start = [self.start copy];
    newDate.is_all_day = self.is_all_day;
    newDate.start_type = [self.start_type copy];
    
    newDate.duration_days = self.duration_days;
    newDate.duration_minutes = self.duration_minutes;
    newDate.duration_hours = self.duration_hours;
    
    return newDate;
}

- (void)convertMinToQuarterMode
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self.start];
    parts.minute += 14;
    
    NSInteger min = [parts minute];
    parts.minute = (min / 15) * 15;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:parts];
    self.start = date;
}


- (NSString *)parseStartTimeString
{
    
    //NSString *dateStr = [NSString stringWithFormat:% %@",intHour,intMin,strAMPM];
    NSString * dateStr = [Utils formateTimeAMPM:self.start];
    NSString *preStr = @"";
    
    if ([self.start_type isEqualToString:START_TYPEEXACTLYAT]) {
        preStr = @"exactly at ";
    }
    else if ([self.start_type isEqualToString:START_TYPEWITHIN]) {
        preStr = @"within an hour of ";
    }
    else if ([self.start_type isEqualToString:START_TYPEAFTER]) {
        preStr = @"anytime after ";
    }
    
    return [preStr stringByAppendingString:dateStr];
}

- (NSString *)parseStartDateString
{
    NSArray *monthNameArray = [NSArray arrayWithObjects:
                               @"Jan",
                               @"Feb",
                               @"March",
                               @"April",
                               
                               @"May",
                               @"June",
                               @"July",
                               @"Aug",
                               
                               @"Sep",
                               @"Oct",
                               @"Nov",
                               @"Dec",
                               nil
                               ];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *parts = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.start];
    
    NSString *monthName = [monthNameArray objectAtIndex:parts.month - 1];
    NSString *preFix = [NSString stringWithFormat:@"%@ %d",monthName,parts.day];
    
    return [NSString stringWithFormat:@"%@,%@",preFix,[self parseStartTimeString]];
}

- (NSString *)parseDuringDateString
{
    
    if (self.is_all_day) {
        return @"all day";
    }
    
    NSString *duringDateString = [NSString stringWithFormat:@"%d hours %d minutes", self.duration_hours, self.duration_minutes];
    
    return duringDateString;
}


#pragma mark -
- (NSComparisonResult)compare:(id)inObject {
    ProposeStart * ps = (ProposeStart *) inObject;
    return [self.start compare:ps.start];
}

@end
