//
//  ProposeStartEntityExtra.h
//  Calvin
//
//  Created by fangxiang on 14-1-12.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProposeStartEntity.h"
#import "ProposeStart.h"

@interface ProposeStartEntity (ProposeStartEntityExtra)

-(void) convertFromProposeStart:(ProposeStart *) ps;

@end
