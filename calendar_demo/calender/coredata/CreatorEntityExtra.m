//
//  CreatorEntityExtra.m
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import "CreatorEntityExtra.h"
#import "CoreDataModel.h"
#import "Utils.h"

@implementation CreatorEntity (CreatorEntityExtra)


+(CreatorEntity *) createCreatorEntity:(NSDictionary *) json
{
    if( [Utils chekcNullClass:json] == nil) {
        return nil;
    }
    
    CreatorEntity * entity = [[CoreDataModel getInstance] createEntity:@"CreatorEntity"];
    
    entity.id         = [json objectForKey:@"id"];
    entity.first_name = [json objectForKey:@"first_name"];
    entity.last_name  = [json objectForKey:@"last_name"];
    entity.avatar_url = [Utils chekcNullClass:[json objectForKey:@"avatar_url"]];
    entity.email      = [json objectForKey:@"email"];
    
    return entity;
}

@end
