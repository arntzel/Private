//
//  FeedEventEntityExtra.h
//  calender
//
//  Created by xiangfang on 13-8-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedEventEntity.h"

#import "Event.h"

@interface FeedEventEntity (FeedEventEntityExtra)


-(UserEntity*) getCreator;


-(void) convertFromEvent:(Event*) event;



@end