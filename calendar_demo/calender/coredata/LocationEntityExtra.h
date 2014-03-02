//
//  LocationEntityExtra.h
//  Calvin
//
//  Created by fangxiang on 14-2-23.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationEntity.h"


@interface LocationEntity (LocationEntityExtra)

+(LocationEntity *) createLocationEntity:(NSDictionary *) json;


@end
