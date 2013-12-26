//
//  EventDetailFinailzeView.h
//  detail
//
//  Created by zyax86 on 13-8-1.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProposeStart.h"

#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import <OHAttributedLabel/OHAttributedLabel.h>


@protocol EventDetailFinailzeViewDelegate <NSObject>

-(void) onRemovePropseStart;

-(void) onSetFinilzeTime;

@end

@interface EventDetailFinailzeView : UIView
@property (retain, nonatomic) IBOutlet UIView *finailzeView;
@property (retain, nonatomic) IBOutlet UIButton *finailzeBtn;
@property (retain, nonatomic) IBOutlet UIView *removeView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *cfmedLabel;
@property (retain, nonatomic) IBOutlet UILabel *declinesLabel;
@property (retain, nonatomic) IBOutlet UIButton *voteStateBtn;
@property (retain, nonatomic) IBOutlet OHAttributedLabel *eventTimeLabel;
@property (retain, nonatomic) IBOutlet UIButton *eventTimeBtn;
@property (retain, nonatomic) IBOutlet UILabel *eventTimeConflictLabel;

- (void)setTime:(NSString *)time;
- (void)setConflictCount:(NSInteger)count;

@property(assign) id<EventDetailFinailzeViewDelegate> delegate;

-(void) updateView:(ProposeStart *) eventTime;

+(EventDetailFinailzeView *) creatView;

+(EventDetailFinailzeView *) creatViewWithStartDate:(NSDate *)date;

@end
