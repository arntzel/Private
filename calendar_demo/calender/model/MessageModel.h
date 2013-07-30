//
//  MessageModel.h
//  calender
//
//  Created by fang xiang on 13-7-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"

@protocol MessageModelDelegate <NSObject>

-(void) onMessageModelChanged;

@optional

-(void) onLoadDataStatusChanged:(BOOL) isLoading;

@end


@interface MessageModel : NSObject

-(void) addDelegate:(id<MessageModelDelegate>) delegate;

-(void) removeDelegate:(id<MessageModelDelegate>) delegate;

-(int) getUnreadMsgCount;

-(void) setUnReadMsgCount:(int) count;


-(NSArray *) getUnreadMsg;

-(void) reloadUnreadMsg;

-(void) readMessage:(Message *) msg;

@end
