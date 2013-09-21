//
//  EventDetailInviteeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailInviteeConformView : UIView

@property (retain, nonatomic) IBOutlet UIButton *tickedBtn;
@property (retain, nonatomic) IBOutlet UIButton *crossedbtn;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *eventTimeConflictLabel;

- (IBAction)tickBtnClick:(id)sender;
- (IBAction)crossBtnClick:(id)sender;

- (void)setTicked;
- (void)setCrossed;

/*
 vote:
 0: not vote yet,
 1: agree,
 2: disagree,
 3: decline the event
 */
-(void) setVoteStatus:(int) vote;

+(EventDetailInviteeConformView *) creatView;
@end
