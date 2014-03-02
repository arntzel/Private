//
//  LocationEntityExtra.m
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "LocationEntityExtra.h"
#import "CoreDataModel.h"
#import "Utils.h"

@implementation LocationEntity (LocationEntityExtra)

+(LocationEntity *) createLocationEntity:(NSDictionary *) json
{
    if( [Utils chekcNullClass:json] == nil) {
        return nil;
    }
    
    LocationEntity * entity = [[CoreDataModel getInstance] createEntity:@"LocationEntity"];
    
    entity.id       = [json objectForKey:@"id"];
    entity.lat      = [Utils chekcNullClass:[json objectForKey:@"lat"]];
    entity.lng      = [Utils chekcNullClass:[json objectForKey:@"lng"]];
    entity.location = [Utils chekcNullClass:[json objectForKey:@"location"]];
    entity.photo    = [Utils chekcNullClass:[json objectForKey:@"photo"]];
    
    return entity;
}
@end
