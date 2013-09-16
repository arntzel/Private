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

@property int vote;

@end
