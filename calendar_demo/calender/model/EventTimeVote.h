//
//  EventTimeVote.h
//  Calvin
//
//  Created by xiangfang on 13-9-15.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface EventTimeVote : NSObject

@property int id;

@property (strong) User * user;

/*
 vote:
 0: not vote yet,
 1: agree,
 2: disagree,
 3: decline the event
 */
@property int vote;

@end
