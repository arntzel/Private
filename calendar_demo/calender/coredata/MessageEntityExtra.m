//
//  MessageEntityExtra.m
//  calender
//
//  Created by fang xiang on 13-8-6.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "MessageEntityExtra.h"

@implementation MessageEntity (MessageEntityExtra)

-(void) convertFromMessage:(Message *) msg
{
    self.id = [NSNumber numberWithInt:msg.id];
    self.subject = msg.subject;
    self.sendTime = msg.sent_at;
    self.eventID = [NSNumber numberWithInt:msg.eventID];
    self.senderName = msg.sender.username;
    self.senderUrl = msg.sender.avatar_url;
    self.unread = [NSNumber numberWithBool:(msg.read_at == nil)];
}
@end
