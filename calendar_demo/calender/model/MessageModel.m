//
//  MessageModel.m
//  calender
//
//  Created by fang xiang on 13-7-30.
//  Copyright (c) 2013年 fang xiang. All rights reserved.
//

#import "MessageModel.h"
#import "Model.h"
#import "CoreDataModel.h"

@implementation MessageModel {
    
    NSMutableArray * delegates;
    
    int unreadMessageCount;

    BOOL loading;
}

-(id) init
{
    self = [super init];
    
    delegates =  [[NSMutableArray alloc] init];
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


-(int ) getMessagesCount
{
    CoreDataModel * dataModel = [CoreDataModel getInstance];
    return [dataModel getMessageCount];
}

-(MessageEntity *) getMessage:(int) offset
{
    CoreDataModel * dataModel = [CoreDataModel getInstance];
    return [dataModel getMessage:offset];
}


-(void) refreshModel:(void (^)(NSInteger error))callback;
{
    [self nofifyModelLoadingStatus:YES];

    [[Model getInstance] getUnreadMessages:^(NSInteger error, NSArray * messages) {
        [self nofifyModelLoadingStatus:NO];
        
        if(error != 0 || messages.count == 0) return;
        
        
        CoreDataModel * dataModel = [CoreDataModel getInstance];
        
        for(Message * msg in messages) {
            
            MessageEntity * entity = [dataModel getMessageByID:msg.id];
            
            if(entity == nil) {
                entity = [dataModel createEntity:@"MessageEntity"];
                [entity convertFromMessage:msg];
            }
        }
        
        [dataModel saveData];
        
        [self nofityModelChanged];
        
        if(callback) callback(error);
    }];
}

-(void) readMessage:(MessageEntity *) msg
{
    msg.unread = NO;
    [[CoreDataModel getInstance] saveData];
    [self nofityModelChanged];
}

-(void) updateMessageReadStatus: (void (^)(NSInteger error))callback
{
    [self setUnReadMsgCount:0];
    [[Model getInstance] readAllMessage:nil];
}

@end
