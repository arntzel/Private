//
//  Invitee.m
//  Calvin
//
//  Created by fang xiang on 13-9-28.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Invitee.h"

@implementation Invitee

-(NSDictionary*)convent2Dic
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.email forKey:@"email"];
    return dic;
}

@end
