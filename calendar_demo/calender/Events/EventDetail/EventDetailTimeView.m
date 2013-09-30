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
#import "Model.h"
#import "UserModel.h"

@interface EventDetailTimeView() <EventDetailTimeVoteViewDelegate>
{


}
@end

@implementation EventDetailTimeView {
    BOOL _isCreator;
    Event * _event;

    UIActivityIndicatorView * _indicatorView;
}

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
    [_event release];
    [_indicatorView release];
    [super dealloc];
}

-(void) showIndicatorView:(BOOL) show
{
    if(_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }

    if(show) {
        _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [_indicatorView startAnimating];
        self.userInteractionEnabled = NO;
        self.alpha = 0.5;
    } else {
        [_indicatorView stopAnimating];
        self.userInteractionEnabled = YES;
        self.alpha = 1;
    }
}

- (EventDetailTimeLabelView * ) createTimeLabelView
{
    EventDetailTimeLabelView * timeLabelView = [EventDetailTimeLabelView creatView];
    
    CGRect frame = timeLabelView.frame;
    frame.origin.x = 0;
    //frame.origin.y = 27;
    timeLabelView.frame = frame;
    
    //[self addSubview:timeLabelView];
    
    return timeLabelView;
}



- (void)layOutSubViews
{
    CGFloat offsetY = 10;
    CGRect frame;
    for(UIView * subView in self.subviews) {

        if(subView.hidden == YES) continue;

        frame = subView.frame;
        frame.origin = CGPointMake(0, offsetY);
        subView.frame = frame;
        offsetY += frame.size.height;
    }
    
    frame = self.frame;
    frame.size.height = offsetY + 20;
    self.frame = frame;

    [self.delegate onEventDetailTimeViewFrameChanged];
}

-(void) updateView:(BOOL) isCreator andEvent:(Event *) event
{
    _isCreator = isCreator;
    [_event release];
    _event = [event retain];

    [self updateView];
}

-(void) updateView
{
    for(UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    NSString * dayTitle = nil;

    NSArray * times = _event.propose_starts;

    for(ProposeStart * eventTime in times) {
        
        NSString * day = [Utils formateDay2:eventTime.start];
        
        if(![day isEqualToString:dayTitle]) {
            EventDetailTimeLabelView * view = [self createTimeLabelView];
            [self addSubview:view];
            dayTitle = day;
            view.title.text = dayTitle;
        }
        
        EventDetailTimeVoteView * voteView = [[EventDetailTimeVoteView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        [self addSubview:voteView];
        voteView.delegate = self;

        [voteView updateView:_isCreator andEvent:_event andEventTimeVote:eventTime];
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


#pragma mark -
#pragma mark EventDetailTimeVoteViewDelegate
-(void) onVoteListClick:(ProposeStart *) eventTime
{

}

-(void) onVoteTimeClick:(ProposeStart *) eventTime
{

}

-(void) onVoteTimeFinalize:(ProposeStart *) eventTime
{

}

-(void) onVoteTimeDelete:(ProposeStart *) eventTime
{
    
    [eventTime retain];
    
    int pid = eventTime.id;
    
    [self showIndicatorView:YES];
    
    [[Model getInstance] deleteProposeStart:pid andCallback:^(NSInteger error) {
        
        [self showIndicatorView:NO];

        if(error == 0) {
            
            NSMutableArray * array = [[NSMutableArray alloc] init];
            for(ProposeStart * p in _event.propose_starts) {
                if(p.id != eventTime.id) {
                    [array addObject:eventTime];
                }
            }
            
            _event.propose_starts = array;
            [array release];
            
            
        }
        
        [eventTime release];
        
        [self updateView];
    }];
}

-(void) onVoteTimeConform:(ProposeStart *) eventTime andChecked:(BOOL) checked
{
    
    [eventTime retain];
    
    int status = checked ? 1 : -1;
 
    [self showIndicatorView:YES];
    
    [[Model getInstance] createVote:eventTime.id andVoteStatus:status andCallback:^(NSInteger error) {
        
        [self showIndicatorView:NO];
        
        if (error == 0) {
            
            for(ProposeStart * p in _event.propose_starts) {
                
                if(p.id == eventTime.id) {
                    NSMutableArray * array = [NSMutableArray arrayWithArray:p.votes];
                    
                    EventTimeVote * vote = [[EventTimeVote alloc] init];
                    vote.email = [[UserModel getInstance] getLoginUser].email;
                    vote.status = status;
                    
                    [array addObject:vote];
                    p.votes = array;
                    
                    [vote release];
                    
                    break;
                }
            }
            
            [self updateView];
            
        } else {
            
        }
        
        [eventTime release];
        
    }];
}

@end
