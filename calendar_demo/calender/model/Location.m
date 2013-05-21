//
//  Location.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Location.h"

@implementation Location


+(Location *) parseLocation:(NSDictionary *) json
{
    Location * location = [[Location alloc] init];

    location.id = [[json objectForKey:@"id"] intValue];
    location.location = [json objectForKey:@"location"];
    location.photo = [json objectForKey:@"photo"];

    
    return location;
}
@end
