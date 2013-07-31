//
//  MessageModel.m
//  calender
//
//  Created by fang xiang on 13-7-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "MessageModel.h"
#import "Model.h"

@implementation MessageModel {
    
    NSMutableArray * delegates;
    
    NSMutableArray * messages;
    
    int unreadMessageCount;

    BOOL loading;
}

-(id) init
{
    self = [super init];
    
    delegates =  [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    unreadMessageCount = 0;
    loading = NO;
    
    return self;
}

-(void) addDelegate:(id<MessageModelDelegate>) delegate
{
    [delegates addObject:delegate];
}

-(void) removeDelegate:(id<MessageModelDelegate>) delegate
{
    [delegates removeObject:delegate];
}

-(void) nofityModelChanged
{
    for(id<MessageModelDelegate> delegate in delegates) {
        [delegate onMessageModelChanged];
    }
}

-(void) nofifyModelLoadingStatus: (BOOL) isLoading
{
    for(id<MessageModelDelegate> delegate in delegates) {
        
        if( [delegate respondsToSelector:@selector(onLoadDataStatusChanged:)]) {
            [delegate onLoadDataStatusChanged:isLoading];
        }
    }
}

-(int) getUnreadMsgCount
{
    return unreadMessageCount;
}

-(void) setUnReadMsgCount:(int) count
{
    unreadMessageCount = count;
    [self nofityModelChanged];
}

-(NSArray *) getMessages
{
    return messages;
}


-(void) loadMoreMsg:(void (^)(NSInteger error))callback
{
    int offset = [messages count];
    
    [[Model getInstance] getMessages:offset andCallback:^(NSInteger error, NSArray * moreMessages) {

        for(Message * msg in moreMessages) {
            [messages addObject:msg];
        }

        callback(error);
    }];
}

-(void) refreshModel:(void (^)(NSInteger error))callback;
{
    [self nofifyModelLoadingStatus:YES];

    [[Model getInstance] getMessages:0 andCallback:^(NSInteger error, NSArray * moreMessages) {

        [self nofifyModelLoadingStatus:NO];

        Message * oldMsg = nil;

        if(messages.count >0) {
            oldMsg = [messages objectAtIndex:0];
        }

        for(int i= moreMessages.count-1; i>=0 ; i--) {
            Message * msg = [moreMessages objectAtIndex:i];

            if(oldMsg != nil || msg.id > oldMsg.id) {
                [messages insertObject:msg atIndex:0];
            }
        }

        [self nofityModelChanged];

        if(callback) callback(error);
    }];
}

-(void) readMessage:(Message *) msg
{
    msg.unread = NO;
    [self nofifyModelLoadingStatus:NO];
}

-(void) updateMessageReadStatus: (void (^)(NSInteger error))callback
{
    [self setUnReadMsgCount:0];
    [[Model getInstance] readAllMessage:nil];
}

@end
