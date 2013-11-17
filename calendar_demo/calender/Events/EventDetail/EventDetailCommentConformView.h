//
//  EventDetailCommentConformView.h
//  calender
//
//  Created by zyax86 on 8/25/13.
//  Copyright (c) 2013 fang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventDetailCommentConformViewDelegate <NSObject>

-(void) onProposeNewTime;
-(void) onAddNewTime;
-(void) onDeclineTime;

@end

@interface EventDetailCommentConformView : UIView

@property(nonatomic, assign) id<EventDetailCommentConformViewDelegate> delegate;

-(void) updateUI:(BOOL) isCreator andInviteeCanProposeTime:(BOOL) can andProposeTimeCount:(int) proposeTimeCount;


@end
