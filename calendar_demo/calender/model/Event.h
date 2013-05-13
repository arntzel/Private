//
//  Event.h
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Event : NSObject

@property int id;

@property NSString * eventDescription;

@property User * user;

@property NSDate * time;

@end
