//
//  MessageEntityExtra.h
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageEntity.h"
#import "Message.h"

@interface MessageEntity (MessageEntityExtra)

-(void) convertFromMessage:(Message *) msg;

@end
