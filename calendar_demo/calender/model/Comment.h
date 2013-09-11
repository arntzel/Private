//
//  Comment.h
//  calender
//
//  Created by fang xiang on 13-9-10.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Comment : NSObject

@property int id;

@property(strong) User * commentor;

@property(strong) NSString * msg;

@property(strong) NSDate * createTime;

@end