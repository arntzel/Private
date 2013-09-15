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

//EventTimeVote list
@property(strong) NSArray * votes;

@end
