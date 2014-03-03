

#import "ProposeStart.h"
#import "Utils.h"
#import "NSDateAdditions.h"

@implementation ProposeStart

-(NSDate *) getEndTime
{
    if(self.is_all_day) {
        NSDate * begin = [self.start cc_dateByMovingToBeginningOfDay];
        NSDate * end = [begin cc_dateByMovingToTheFollowingDayCout:self.duration_days];
        return end;
    } else {
        int durationSeconds =  [self getDurationMins]*60;
        return [self.start dateByAddingTimeInterval:durationSeconds];
    }
}

-(int) getDurationMins
{
   
    
   return self.duration_minutes + self.duration_hours*60 + self.duration_days*60*24;
}

-(NSDictionary*) convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    if(self.id > 0) {
        [dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];
    }

    [dic setObject:[Utils formateGMTDate:self.start] forKey:@"start"];
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
        start.duration_days = [num intValue];
    }

    num = [Utils chekcNullClass:[json objectForKey:@"duration_hours"]];
    if(num != nil) {
        start.duration_hours = [num intValue];
    }

    num = [Utils chekcNullClass:[json objectForKey:@"duration_minutes"]];
    if(num != nil) {
        start.duration_minutes = [num intValue];
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
    newDate.end = [self.end copy];
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


-(NSString *) getVoteTimeLabel
{
    NSString * startTime = [Utils formateTimeAMPM:self.start];
    NSString * endTime = [Utils formateTimeAMPM:[self getEndTime]];
    NSString * day =  [Utils formateDay:self.start];
    NSString * lable = [NSString stringWithFormat:@"%@-%@ %@", startTime, endTime, day];
    return lable;
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

- (NSString *)parseStartTimeStringWithFirstCapitalized
{
    
    //NSString *dateStr = [NSString stringWithFormat:% %@",intHour,intMin,strAMPM];
    //NSString * dateStr = [Utils formateTimeAMPM:self.start];
    NSString *preStr = @"";
    
    if ([self.start_type isEqualToString:START_TYPEEXACTLYAT]) {
        preStr = @"Exactly At ";
    }
    else if ([self.start_type isEqualToString:START_TYPEWITHIN]) {
        preStr = @"Within An Hour Of ";
    }
    else if ([self.start_type isEqualToString:START_TYPEAFTER]) {
        preStr = @"Anytime After ";
    }
    
    return preStr;
}

- (NSString *)parseStartDateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MMM d"];
    NSString * day = [dateFormatter stringFromDate:self.start];
    
    return [NSString stringWithFormat:@"%@ %@", day, [self parseStartTimeString]];
}

- (NSString *)parseDuringDateString
{
    
    if (self.is_all_day) {
        return [NSString stringWithFormat:@"all %d days",self.duration_days];
    }
    
    NSString *duringDateString = [NSString stringWithFormat:@"%d hours %d minutes", self.duration_hours, self.duration_minutes];
    
    return duringDateString;
}

- (NSString *)parseDuringDateString2
{
    
    if (self.is_all_day) {
        return [NSString stringWithFormat:@"All <font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%d</font> days",self.duration_days];
    }
    
//    NSString *duringDateString = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Bold\" size=\"17\">%d</font> Hours <font name=\"Helvetica Neue Bold\" size=\"17\">%d</font> Minutes", self.duration_hours, self.duration_minutes];
    
    NSString *hour = @"hour";
    if (self.duration_hours > 1) {
        hour = @"hours";
    }
    NSString *duringDateString = [NSString stringWithFormat:@"<font name=\"Helvetica Neue Medium\" size=\"15\" color=\"#494949\">%d</font> %@", self.duration_hours, hour];
    
    return duringDateString;
}


#pragma mark -
- (NSComparisonResult)compare:(id)inObject {
    ProposeStart * ps = (ProposeStart *) inObject;
    return [self.start compare:ps.start];
}


-(BOOL) isEqual:(id)object {

    if(object == nil) return  NO;
    
    ProposeStart * ps = (ProposeStart *) object;


    BOOL result = [self.start isEqualToDate:ps.start];

    if(result == NO) {
        return NO;
    }

    result = [self.start_type isEqualToString:ps.start_type];
    if(result == NO) {
        return NO;
    }

    result = (self.is_all_day == ps.is_all_day);

    if(result == NO) {
        return NO;
    }

    return (self.duration_minutes == ps.duration_minutes) &&
           (self.duration_hours == ps.duration_hours) &&
           (self.duration_days == ps.duration_days);
}

-(int)getAcceptCount
{
    int totalAccpet = 0;
    
    for (EventTimeVote *vote in self.votes) {
        if (vote.status == 1) {
            totalAccpet ++;
        }
    }
    return totalAccpet;
}

-(int)getDeclinedCount
{
    int totalDecline = 0;
    
    for (EventTimeVote *vote in self.votes) {
        if (vote.status == -1) {
            totalDecline ++;
        }
    }
    return totalDecline;
}

@end
