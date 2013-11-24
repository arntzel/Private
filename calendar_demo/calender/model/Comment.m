//
//  Comment.m
//  calender
//
//  Created by fang xiang on 13-9-10.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Comment.h"
#import "Utils.h"


@implementation Comment

- (NSComparisonResult) compare:(Comment *) cmt
{
    NSDate* d1 = self.createTime;
    NSDate* d2 = cmt.createTime;
    
    return [d1 compare:d2];
}

-(NSDictionary*)convent2Dic
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSString * msg = [self.msg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setObject:msg forKey:@"content"];
    
    NSString * eventUri = [NSString stringWithFormat:@"/api/v1/event/%d", self.eventID];
    [dic setObject:eventUri forKey:@"event"];
    return dic;
}

+(Comment *) parseComment:(NSDictionary *) json
{
    Comment * cmt = [[Comment alloc] init];
    
    cmt.id = [[json objectForKey:@"id"] intValue];

    int type = [[json objectForKey:@"type"] intValue];

    NSString * msg = @"";
    NSString * content = [json objectForKey:@"content"];
    switch (type) {
        case 0: {
            msg = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        }

        case 1: {

            NSString * eventTime = [self parseEventTime:content];
            msg = [NSString stringWithFormat:@"Just has proposed new time %@", eventTime];
            break;
        }

        case 2: {

            NSString * eventTime = [self parseEventTime:content];
            msg = [NSString stringWithFormat:@"Just has accepted new time %@", eventTime];
            break;
        }

        case 3: {

            NSString * eventTime = [self parseEventTime:content];
            msg = [NSString stringWithFormat:@"Just has rejected new time %@", eventTime];
            break;
        }

        case 4: {
            msg = @"Decline event";
            break;
        }

        case 5: {
            NSString * eventTime = [self parseEventTime:content];
            msg = [NSString stringWithFormat:@"All invitees confirmed for %@", eventTime];
            break;
        }

        default:
            break;
    }

    cmt.msg = msg;
    cmt.createTime = [Utils parseNSDate:[json objectForKey:@"created"]];

    NSDictionary * dic = [Utils chekcNullClass:[json objectForKey:@"contact"]];
    if(dic != nil) {
        cmt.commentor = [Contact parseContact:dic];
    }
    return cmt;
}


+(NSString *) parseEventTime:(NSString *) time
{
    NSArray * dates = [time componentsSeparatedByString:@" "];

    if(dates.count !=2) {
        return @"";
    }

    NSDate * start =  [Utils convertLocalDate:[Utils parseNSDate:[dates objectAtIndex:0]]];
    NSDate * end = [Utils convertLocalDate:[Utils parseNSDate:[dates objectAtIndex:1]]];

    NSString * startTime = [Utils formateTimeAMPM:start];
    NSString * startDay = [Utils formateDay3:start];
    NSString * endTime = [Utils formateTimeAMPM:end];
    NSString * endDay = [Utils formateDay3:end];

    if([startDay isEqualToString:endDay]) {
        return  [NSString stringWithFormat:@"%@-%@ %@", startTime, endTime, startDay];
    } else {
        return  [NSString stringWithFormat:@"%@ %@ - %@ %@", startTime, startDay, endTime, endDay];
    }
}
@end
