//
//  EventTime.h
//  Calvin
//
//  Created by xiangfang on 13-9-15.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventTimeVote.h"

@interface EventTime : NSObject

@property int id;

@property(strong) NSDate * startTime;
@property(strong) NSDate * endTime;

/**
 0: not yet
 1: finalized
 2: decline
 */
@property int finalized;

//EventTimeVote list
@property(strong) NSArray * votes;

@end
