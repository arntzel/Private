//
//  EventDetailTimeView.m
//  detail
//
//  Created by zyax86 on 13-8-4.
//  Copyright (c) 2013年 zyax86. All rights reserved.
//

#import "EventDetailTimeView.h"
#import "EventDetailFinailzeView.h"
#import "EventDetailHeader.h"
#import "EventDetailInviteeConformView.h"
#import "EventDetailTimeLabelView.h"
#import "EventDetailHeaderListView.h"

#import "EventDetailTimeVoteView.h"

#import "Utils.h"

@interface EventDetailTimeView()
{
    //EventDetailTimeLabelView *timeLabelView;
    
    

}
@end

@implementation EventDetailTimeView

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self addTimeLabelView];
//        [self addFinailzeView];
//        [self addInviteeListView];
//        
//        [self addConformView];
        
        [self updateUI];
    }
    return self;
}

- (void)dealloc
{    
    [super dealloc];
}



- (EventDetailTimeLabelView * ) createTimeLabelView
{
    EventDetailTimeLabelView * timeLabelView = [EventDetailTimeLabelView creatView];
    
    CGRect frame = timeLabelView.frame;
    frame.origin.x = 7;
    //frame.origin.y = 27;
    timeLabelView.frame = frame;
    
    //[self addSubview:timeLabelView];
    
    return timeLabelView;
}



- (void)layOutSubViews
{
    CGFloat offsetY = 0;
    CGRect frame;
    for(UIView * subView in self.subviews) {
        frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }
    
    frame = self.frame;
    frame.size.height = offsetY;
    self.frame = frame;
}

-(void) updateView:(BOOL) isCreator andEventTimes:(NSArray *) times;
{
    for(UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    NSString * dayTitle = nil;
    
    for(EventTime * eventTime in times) {
        
        NSString * day = [Utils formateDay:eventTime.startTime];
        
        if(![day isEqualToString:dayTitle]) {
            EventDetailTimeLabelView * view = [self createTimeLabelView];
            [self addSubview:view];
            dayTitle = day;
            view.title.text = dayTitle;
        }
        
        EventDetailTimeVoteView * voteView = [[EventDetailTimeVoteView alloc] init];
        [self addSubview:voteView];
        [voteView updateView:isCreator andEventTimeVote:eventTime];
        [voteView release];
    }
    
    
    [self layOutSubViews];
}


- (void)updateUI
{
    [self setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0]];
    
//    CGRect timeContentViewFrame = self.frame;
//    timeContentViewFrame.size = CGSizeMake(320, conformView.frame.origin.y + conformView.frame.size.height + 20);
//    self.frame = timeContentViewFrame;
}
@end
