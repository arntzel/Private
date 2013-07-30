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
    
    NSMutableArray * unreadMessages;
    
    int unreadMessageCount;
}

-(id) init
{
    self = [super init];
    
    delegates =  [[NSMutableArray alloc] init];
    unreadMessages = [[NSMutableArray alloc] init];
    unreadMessageCount = 0;
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

-(NSArray *) getUnreadMsg
{
    return unreadMessages;
}

-(void) reloadUnreadMsg
{
    [[Model getInstance] getUnreadMessages:^(NSInteger error, NSArray *messages) {
        
        if(error == 0) {
            [unreadMessages removeAllObjects];
            [unreadMessages addObjectsFromArray:messages];
            unreadMessageCount = unreadMessages.count;
            [self nofityModelChanged];
        }
    }];
}

-(void) readMessage:(Message *) msg
{
    [self nofifyModelLoadingStatus:YES];
    
    [[Model getInstance]  readMessage:msg.id andCallback:^(NSInteger error, int msgID) {
    
        [self nofifyModelLoadingStatus:NO];
    
        
        if(error != 0) return;
        
        for(Message * msg in unreadMessages) {
            if(msg.id == msgID) {
                [unreadMessages removeObject:msg];
                break;
            }
        }
        
        unreadMessageCount = unreadMessages.count;
        [self nofityModelChanged];
    }];
}

@end
