//
//  Location.m
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "Location.h"
#import "Utils.h"

@implementation Location

- (id)copyWithZone:(NSZone *)zone
{
    Location *copy = [[Location alloc] init];
    copy.photo = [self.photo copy];
    copy.location = [self.location copy];
    copy.lat = self.lat;
    copy.lng = self.lng;
    
    return copy;
}


+(Location *) parseLocation:(NSDictionary *) json
{
    Location * location = [[Location alloc] init];

    location.id = [[json objectForKey:@"id"] intValue];
    location.location = [Utils chekcNullClass:[json objectForKey:@"location"]];
    location.photo =  [Utils chekcNullClass:[json objectForKey:@"photo"]];

    id obj = [json objectForKey:@"lat"];
    if(![obj isKindOfClass: [NSNull class]]) {
        location.lat = [obj floatValue];
    }

    obj = [json objectForKey:@"lng"];
    if(![obj isKindOfClass: [NSNull class]]) {
        location.lng = [obj floatValue];
    }

    return location;
}

-(NSDictionary*)convent2Dic
{

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];

    [dic setObject:[NSNumber numberWithInt:self.id] forKey:@"id"];
    if(self.location != nil) {
       [dic setObject:self.location forKey:@"location"];
    }

    if(self.photo != nil) {
        [dic setObject:self.photo forKey:@"photo"];
    }
    

    [dic setObject:[NSNumber numberWithFloat:self.lat] forKey:@"lat"];
    [dic setObject:[NSNumber numberWithFloat:self.lng] forKey:@"lng"];

    return dic;
}

-(BOOL) isValid
{
    return self.lat != 0 && self.lng != 0;
}
@end
