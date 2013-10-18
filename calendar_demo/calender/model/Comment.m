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
    NSString * msg = [json objectForKey:@"content"];
    cmt.msg = [msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    cmt.createTime = [Utils parseNSDate:[json objectForKey:@"created"]];

    NSDictionary * dic = [Utils chekcNullClass:[json objectForKey:@"user"]];
    if(dic != nil) {
        cmt.commentor = [User parseUser:dic];
    }
    return cmt;
}

@end
