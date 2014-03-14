//
//  EventDetailTimeView.h
//  Calvin
//
//  Created by fangxiang on 14-3-2.
//  Copyright (c) 2014年 Pencil Me, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "ProposeStart.h"

@protocol EventDetailTimeViewItemDelegate <NSObject>

-(void) onVoteBtnClicked:(ProposeStart *) time;

-(void) onConformBtnClicked:(ProposeStart *) time;

-(void) onTimeLabelClicked:(ProposeStart *) time;

-(void) onAttendeeLabelClicked:(ProposeStart *) time;

-(void) onRemovePropseStart:(ProposeStart *) time;

@end



@interface EventDetailTimeViewItem : UIView <UIGestureRecognizerDelegate>

@property IBOutlet UILabel * labelDate;
@property IBOutlet UILabel * labelTime;
@property IBOutlet UILabel * labelConfirmed;

@property IBOutlet UILabel * labelAtdCount;

@property IBOutlet UIButton * buttonVote;
@property IBOutlet UIButton * buttonConform;

@property IBOutlet UIImageView * arrowTime;
@property IBOutlet UIImageView * arrowAttendee;

@property IBOutlet UIView * attentCountView;


-(IBAction) buttonVoteClicked:(id)sender;

-(IBAction) buttonConformClicked:(id)sender;

-(IBAction) timeLabelClicked:(id)sender;

-(IBAction) attendeeLabelClicked:(id)sender;



@property(assign)  id<EventDetailTimeViewItemDelegate> delegate;



-(void) refreshView:(Event *) event andTime:(ProposeStart *) time;

@end


