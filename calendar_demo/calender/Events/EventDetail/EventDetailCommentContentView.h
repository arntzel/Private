//
//  EventDetailCommentContentView.h
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Comment.h"

@protocol EventDetailCommentContentViewDelegate <NSObject>

-(void) onEventDetailCommentContentViewFrameChanged;

-(void) onNewCommnet;

@end

@interface EventDetailCommentContentView : UIView

@property int eventID;

@property BOOL loaded;

@property(nonatomic, assign) id<EventDetailCommentContentViewDelegate> delegate;

- (id)init;

-(void) updateView:(User *) me andComments:(NSArray *) comments;

-(void) setDecliend:(BOOL) declined;

- (void)startLoadComment;

@end
