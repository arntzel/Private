//
//  Plan.h
//  calender
//
//  Created by fang xiang on 13-5-4.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "User.h"

@interface Plan : NSObject

@property int id;

@property NSString * title;

@property NSDate * time;

@property User * host;

@property int status;

@property Location * location;

//@property NSMutableArray * attendees;
@property NSString * attenedees;

@end
