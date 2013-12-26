//
//  EventDetailInviteeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import <OHAttributedLabel/OHAttributedLabel.h>


@interface EventDetailInviteeConformView : UIView

@property (weak, nonatomic) IBOutlet UIButton *tickedBtn;
@property (weak, nonatomic) IBOutlet UIButton *crossedbtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet OHAttributedLabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeConflictLabel;
@property (weak, nonatomic) IBOutlet UIImageView *finalizedTick;
@property (weak, nonatomic) IBOutlet UILabel *finalizedLabel;
@property (weak, nonatomic) IBOutlet UILabel *cfmedLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteStateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *viewVoteArrow;

@property (weak, nonatomic) IBOutlet UILabel *declinesLabel;

- (IBAction)tickBtnClick:(id)sender;
- (IBAction)crossBtnClick:(id)sender;

- (void)setTicked;
- (void)setCrossed;

- (void)showFinalizedFlag;

- (void)setTime:(NSString *)time;
- (void)setConflictCount:(NSInteger)count;

/*
 vote:
 0: not vote yet,
 1: agree,
 2: disagree,
 3: decline the event
 */
-(void) setVoteStatus:(int) vote;

+(EventDetailInviteeConformView *) creatView;

+(EventDetailInviteeConformView *) creatViewWithStartDate:(NSDate *)date;
@end
