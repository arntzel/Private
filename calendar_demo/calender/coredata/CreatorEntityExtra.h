//
//  CreatorEntityExtra.h
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreatorEntity.h"

@interface CreatorEntity (CreatorEntityExtra)


+(CreatorEntity *) createCreatorEntity:(NSDictionary *) json;



@end
