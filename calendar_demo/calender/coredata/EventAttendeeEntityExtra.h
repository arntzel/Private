//
//  EventAttendeeEntityExtra.h
//  Calvin
//
//  Created by fangxiang on 14-3-5.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventAttendeeEntity.h"

@interface EventAttendeeEntity (EventAttendeeEntityExtra)


+(EventAttendeeEntity *) createEventAttendeeEntity:(NSDictionary *) json;

@end