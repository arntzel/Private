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


-(NSDictionary*)convent2Dic
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.msg forKey:@"content"];
    
    NSString * eventUri = [NSString stringWithFormat:@"/api/v1/event/%d", self.eventID];
    [dic setObject:eventUri forKey:@"event"];
    return dic;
}

+(Comment *) parseComment:(NSDictionary *) json
{
    Comment * cmt = [[Comment alloc] init];
    
    cmt.id = [[json objectForKey:@"id"] intValue];
    cmt.msg = [json objectForKey:@"content"];
    
    NSDate * creatTime = [Utils parseNSDate:[json objectForKey:@"created"]];
    cmt.createTime = [Utils convertLocalDate:creatTime];
    cmt.commentor = [User parseUser:[json objectForKey:@"user"]];
    return cmt;
}

@end
