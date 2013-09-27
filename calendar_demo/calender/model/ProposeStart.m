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

-(NSDictionary*) convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[Utils formateDate:self.start] forKey:@"start"];
    [dic setObject:self.start_type forKey:@"start_type"];

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


    NSArray *  voteJsons = [json objectForKey:@"vote"];

    NSMutableArray * votes = [[NSMutableArray alloc] init];
    for(NSDictionary * voteJson in voteJsons) {
        EventTimeVote * vote = [EventTimeVote parse:voteJson];
        [votes addObject:vote];
    }

    start.votes = votes;
    return  start;
}

@end
